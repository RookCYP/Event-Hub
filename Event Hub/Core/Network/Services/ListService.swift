//
//  ListService.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 14.09.25.
//

import Foundation

protocol ListServiceProtocol {
    func fetchLists(
        location: String,
        page: Int,
        pageSize: Int
    ) async throws -> ListsResponse
    
    func fetchListDetails(id: String) async throws -> EventList
    func fetchNextPage(from urlString: String) async throws -> ListsResponse
}

final class ListService: ListServiceProtocol {
    private let api = APIClient.shared
    
    func fetchLists(
        location: String,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> ListsResponse {
        return try await api.request(
            endpoint: .lists,
            parameters: [
                "location": location,
                "page": page,
                "page_size": pageSize,
                "fields": "id,title,slug,description,publication_date,images,place_count,item_count",
                "expand": "images"
            ]
        )
    }
    
    func fetchListDetails(id: String) async throws -> EventList {
        return try await api.request(
            endpoint: .listDetails(id: id),
            parameters: [
                "fields": "id,title,slug,description,body_text,images,publication_date",
                "expand": "images"
            ]
        )
    }
    
    func fetchNextPage(from urlString: String) async throws -> ListsResponse {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        return try await api.request(url: url)
    }
}
