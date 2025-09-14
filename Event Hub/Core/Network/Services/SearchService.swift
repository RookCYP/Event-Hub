//
//  SearchService.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//

// /Core/Network/Services/SearchService.swift
protocol SearchServiceProtocol {
    func searchEvents(query: String, location: String) async throws -> SearchResponse
    func searchPlaces(query: String, location: String) async throws -> SearchResponse
    func searchAll(query: String, location: String) async throws -> SearchResponse
}

final class SearchService: SearchServiceProtocol {
    private let api = APIClient.shared
    
    // Поиск только событий (для Explore)
    func searchEvents(query: String, location: String) async throws -> SearchResponse {
        return try await api.request(
            endpoint: .search,
            parameters: [
                "q": query,
                "location": location,
                "ctype": "event",
                "page_size": 20,
                "expand": "place,dates"
            ]
        )
    }
    
    // Поиск только мест (для Map)
    func searchPlaces(query: String, location: String) async throws -> SearchResponse {
        return try await api.request(
            endpoint: .search,
            parameters: [
                "q": query,
                "location": location,
                "ctype": "place",
                "page_size": 20
            ]
        )
    }
    
    // Универсальный поиск
    func searchAll(query: String, location: String) async throws -> SearchResponse {
        return try await api.request(
            endpoint: .search,
            parameters: [
                "q": query,
                "location": location,
                "page_size": 20,
                "expand": "place,dates"
            ]
        )
    }
}
