//
//  EventService.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 08.09.25.
//

import Foundation
import SwiftUI

// Services Layer (Domain-Specific)
//  /Core/Network/Services/EventService.swift

// MARK: - EventService
protocol EventServiceProtocol {
    func fetchEvents(
        location: String,
        dateRange: DateRange?,
        page: Int,
        pageSize: Int,
        categories: [String]?
    ) async throws -> EventsResponse

    func fetchEventDetails(id: String) async throws -> Event
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
        dateRange: DateRange?,
        page: Int = 1,
        pageSize: Int = 20,
        categories: [String]? = nil
    ) async throws -> EventsResponse {
        var params: [String: Any] = [
            "location": location,
            "page": page,
            "page_size": pageSize,
            "fields": FieldSet.list,  // ← Сокращенный набор для списка
            "expand": "place,location,dates"  // ← Без participants
        ]
        if let categories, !categories.isEmpty {
            params["categories"] = categories.joined(separator: ",")
        }
        if let dateRange = dateRange {
            params["actual_since"] = Int(dateRange.from.timeIntervalSince1970)
            params["actual_until"] = Int(dateRange.to.timeIntervalSince1970)
        }
        
        return try await apiClient.request(endpoint: .events, parameters: params)
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
}
