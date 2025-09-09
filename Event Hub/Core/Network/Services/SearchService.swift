//
//  SearchService.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//


// /Core/Network/Services/SearchService.swift
protocol SearchServiceProtocol {
    func search(query: String, location: String) async throws -> [SearchResult]
}

final class SearchService: SearchServiceProtocol {
    private let api = APIClient.shared
    
    func search(query: String, location: String) async throws -> [SearchResult] {
        let response: SearchResponse = try await api.request(
            endpoint: .events, // можно и /search/, но KudaGo позволяет фильтровать events
            parameters: [
                "location": location,
                "q": query,
                "page_size": 20,
                "fields": "id,title,description,dates,place,images,location,categories,site_url",
                "expand": "place,location,dates"
            ]
        )
        return response.results.map {
            // Если останешься на /events/, можно собрать SearchResult самодельно; если /search/,
            // то использовать твои модели как есть:
            SearchResult(id: $0.id, title: $0.title, description: $0.description, ctype: "event", objectId: $0.id)
        }
    }
}
