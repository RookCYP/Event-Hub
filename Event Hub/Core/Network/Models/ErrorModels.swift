//
//  ErrorModels.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//

//  /Core/Network/Models/ErrorModels.swift
// MARK: - Error Models

import Foundation
// Общие ошибки клиента
enum APIError: Error, LocalizedError, Equatable {
    case invalidURL
    case transport(Error)
    case server(status: Int, body: Data?)
    case decoding(Error)
    case cancelled
    case emptyData
    case rateLimited(retryAfter: TimeInterval?)
    
    // MARK: - Equatable (сравниваем только "тип" ошибки)
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.cancelled, .cancelled),
             (.emptyData, .emptyData):
            return true
        case (.server(let l, _), .server(let r, _)):
            return l == r
        case (.rateLimited, .rateLimited):
            return true
        case (.transport, .transport),
             (.decoding, .decoding):
            return true
        default:
            return false
        }
    }
    
    // MARK: - LocalizedError
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .transport(let e):
            return "Transport error: \(e.localizedDescription)"
        case .server(let status, _):
            return "Server error (HTTP \(status))"
        case .decoding(let e):
            return "Decoding error: \(e.localizedDescription)"
        case .cancelled:
            return "Request was cancelled"
        case .emptyData:
            return "Response contained no data"
        case .rateLimited(let retryAfter):
            if let seconds = retryAfter {
                return "Rate limited – retry after \(seconds) sec"
            } else {
                return "Rate limited – please retry later"
            }
        }
    }
}

struct APIErrorResponse: Codable {
    let error: String?
    let detail: String?
    let message: String?
}
