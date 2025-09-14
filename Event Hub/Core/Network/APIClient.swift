//
//  APIClient.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 08.09.25.
//

import Foundation

// MARK: - APIClient

// /Core/Network/APIClient.swift

import Foundation

actor APIClient {
    static let shared = APIClient()
    
    private let baseURL = URL(string: "https://kudago.com/public-api/v1.4")!
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    private let maxRetryCount = 2
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.waitsForConnectivity = true
        config.requestCachePolicy = .useProtocolCachePolicy
        config.urlCache = URLCache(memoryCapacity: 32 * 1024 * 1024, diskCapacity: 256 * 1024 * 1024, diskPath: "EventHubURLCache")
        self.session = URLSession(configuration: config)
        
        let decoder = JSONDecoder()
        // KudaGo: даты часто как Unix timestamp (Int), но иногда ISO строки.
        // Будем декодировать вручную в моделях по полям; тут оставим ISO для строк.
        decoder.dateDecodingStrategy = .iso8601
        self.jsonDecoder = decoder
    }
    
    // MARK: - Публичные апи
    
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        parameters: [String: Any]? = nil
    ) async throws -> T {
        let url = try buildURL(endpoint: endpoint, query: parameters)
        return try await request(url: url)
    }
    
    /// Прямой запрос по абсолютному URL (для пагинации next/previous)
    func request<T: Decodable>(url: URL) async throws -> T {
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return try await execute(request: req)
    }
    
    // MARK: - Внутренняя кухня
    
    private func execute<T: Decodable>(request: URLRequest) async throws -> T {
        var attempt = 0
        let currentRequest = request
        
        while true {
            do {
                let (data, response) = try await session.data(for: currentRequest, delegate: nil)
                try Task.checkCancellation()
                
                guard let http = response as? HTTPURLResponse else {
                    throw APIError.transport(URLError(.badServerResponse))
                }
                
                switch http.statusCode {
                case 200...299:
                    guard !data.isEmpty else { throw APIError.emptyData }
                    do {
                        return try jsonDecoder.decode(T.self, from: data)
                    } catch let decodingError as DecodingError {
                        #if DEBUG
                        switch decodingError {
                        case .typeMismatch(let type, let ctx):
                            print("Type mismatch for \(type) at path: \(ctx.codingPath.map{ $0.stringValue }.joined(separator: "."))")
                        case .valueNotFound(_, let ctx):
                            print("Value not found at path: \(ctx.codingPath.map{ $0.stringValue }.joined(separator: ".")) – \(ctx.debugDescription)")
                        case .keyNotFound(let key, let ctx):
                            print("Key not found '\(key.stringValue)' at path: \(ctx.codingPath.map{ $0.stringValue }.joined(separator: ".")) – \(ctx.debugDescription)")
                        case .dataCorrupted(let ctx):
                            print("Data corrupted at path: \(ctx.codingPath.map{ $0.stringValue }.joined(separator: ".")) – \(ctx.debugDescription)")
                        @unknown default:
                            print("DecodingError: \(decodingError)")
                        }
                        if let preview = String(data: data.prefix(2048), encoding: .utf8) {
                            print("Body preview:\n\(preview)")
                        }
                        #endif
                        throw APIError.decoding(decodingError)
                    } catch {
                        #if DEBUG
                        if let preview = String(data: data.prefix(2048), encoding: .utf8) {
                            print("Decoding failed for \(T.self). Body preview:\n\(preview)")
                        }
                        #endif
                        throw APIError.decoding(error)
                    }
                    
                case 304:
                    // Not modified - можно вернуть ошибку или закэшированные данные, (если они хранятся) выше.
                    throw APIError.emptyData // Пока отдаём emptyData.
                    
                case 429:
                    // Rate limit
                    let retry = retryAfter(from: http)
                    throw APIError.rateLimited(retryAfter: retry)
                    
                case 500, 502, 503, 504:
                    if attempt < maxRetryCount {
                        attempt += 1
                        let backoff = pow(2.0, Double(attempt)) // 2, 4 сек
                        try await Task.sleep(nanoseconds: UInt64(backoff * 1_000_000_000))
                        continue
                    } else {
                        throw APIError.server(status: http.statusCode, body: data)
                    }
                    
                default:
                    // Попробуем распарсить error body как APIErrorResponse
                    if let apiErr = try? jsonDecoder.decode(APIErrorResponse.self, from: data) {
                        let detail = apiErr.detail ?? apiErr.error ?? apiErr.message ?? "Unknown"
                        throw APIError.server(status: http.statusCode, body: Data(detail.utf8))
                    } else {
                        throw APIError.server(status: http.statusCode, body: data)
                    }
                }
            } catch is CancellationError {
                throw APIError.cancelled
            } catch APIError.rateLimited(let retryAfter) {
                // Один аккуратный retry при 429
                if attempt < maxRetryCount {
                    attempt += 1
                    let delay = retryAfter ?? 2.0
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    continue
                } else {
                    throw APIError.rateLimited(retryAfter: retryAfter)
                }
            } catch {
                // Транспортные/прочие
                if let urlErr = error as? URLError, urlErr.code == .timedOut, attempt < maxRetryCount {
                    attempt += 1
                    let backoff = pow(2.0, Double(attempt))
                    try await Task.sleep(nanoseconds: UInt64(backoff * 1_000_000_000))
                    continue
                }
                throw APIError.transport(error)
            }
        }
    }
    
    private func buildURL(endpoint: APIEndpoint, query: [String: Any]?) throws -> URL {
        let url = baseURL.appendingPathComponent(endpoint.path)
        guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        if let query = query, !query.isEmpty {
            comps.queryItems = query.flatMap { key, value -> [URLQueryItem] in
                // Поддержка массивов и простых типов
                if let arr = value as? [CustomStringConvertible] {
                    return [URLQueryItem(name: key, value: arr.map(\.description).joined(separator: ","))]
                } else {
                    return [URLQueryItem(name: key, value: String(describing: value))]
                }
            }
        }
        guard let final = comps.url else { throw APIError.invalidURL }
        return final
    }
    
    private func retryAfter(from http: HTTPURLResponse) -> TimeInterval? {
        if let header = http.value(forHTTPHeaderField: "Retry-After"),
           let seconds = TimeInterval(header) {
            return seconds
        }
        return nil
    }
}
