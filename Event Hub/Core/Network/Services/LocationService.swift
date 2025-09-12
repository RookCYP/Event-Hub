//
//  LocationService.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//


// /Core/Network/Services/LocationService.swift
protocol LocationServiceProtocol {
    func fetchLocations() async throws -> [Location]
}

final class LocationService: LocationServiceProtocol {
    private let api = APIClient.shared
    
    func fetchLocations() async throws -> [Location] {
        // Напрямую декодируем массив, не wrapper
        let locations: [Location] = try await api.request(
            endpoint: .locations,
            parameters: [
                "fields": "slug,name,timezone,coords,language,currency",
                "page_size": 100
            ]
        )
        return locations
    }
}
