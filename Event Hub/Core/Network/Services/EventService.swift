//
//  EventService.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 08.09.25.
//

import Foundation
import SwiftUI

//  /Core/Network/Services/EventService.swift
// Services Layer (Domain-Specific)

// MARK: - EventService
protocol EventServiceProtocol {
    func fetchEvents(
        location: String,
        page: Int,
        pageSize: Int,
        categories: [String]?,
        actualSince: Date?,
        actualUntil: Date?
    ) async throws -> EventsResponse

//    func fetchEventDetails(id: String) async throws -> Event
//    func searchEvents(query: String, location: String, page: Int, pageSize: Int) async throws -> SearchResponse
    func fetchNextPage(from urlString: String) async throws -> EventsResponse

}


final class EventService: EventServiceProtocol {
    private let apiClient = APIClient.shared

    // Константы для наборов полей
    private enum FieldSet {
        static let list = "id,dates,title,short_title,slug,place,location,categories,age_restriction,price,is_free,images"
        static let detail = "id,publication_date,dates,title,short_title,slug,place,description,body_text,location,categories,tagline,age_restriction,price,is_free,images,favorites_count,comments_count,site_url,tags,participants"
    }
    
    func fetchEvents(
        location: String,
        page: Int = 1,
        pageSize: Int = 20,
        categories: [String]? = nil,
        actualSince: Date? = nil,
        actualUntil: Date? = nil
    ) async throws -> EventsResponse {
        var parameters: [String: Any] = [
            "location": location,
            "page": page,
            "page_size": pageSize,
            "fields": FieldSet.list,  // ← Сокращенный набор для списка
            "expand": "place,location,dates"  // ← Без participants
        ]
        if let categories, !categories.isEmpty {
            parameters["categories"] = categories.joined(separator: ",")
        }
        if let actualSince { parameters["actual_since"] = Int(actualSince.timeIntervalSince1970) }
        if let actualUntil { parameters["actual_until"] = Int(actualUntil.timeIntervalSince1970) }
        
        return try await apiClient.request(endpoint: .events, parameters: parameters)
    }

    func fetchNextPage(from urlString: String) async throws -> EventsResponse {
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }
        return try await apiClient.request(url: url)
    }
    
    func fetchEventDetails(id: String) async throws -> Event {
        try await apiClient.request(endpoint: .eventDetails(id: id), parameters: [
            "fields": FieldSet.detail,  // ← Полный набор для деталей
            "expand": "place,location,dates,participants"
        ])
    }

    func searchEvents(query: String, location: String, page: Int = 1, pageSize: Int = 20) async throws -> SearchResponse {
        try await apiClient.request(endpoint: .search, parameters: [
            "q": query,
            "location": location,
            "page": page,
            "page_size": pageSize,
            "fields": FieldSet.list  // ← Тоже сокращенный для поиска
        ])
    }
}
