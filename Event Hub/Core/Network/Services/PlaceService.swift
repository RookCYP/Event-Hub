//
//  PlaceService.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 13.09.25.
//


// /Modules/Shared/Services/PlaceService.swift
import Foundation

protocol PlaceServiceProtocol {
    func fetchPlaces(
        location: String,
        pageSize: Int?,
        categories: [String]?
    ) async throws -> PlacesResponse
    
    func fetchNearbyPlaces(
        location: String,
        coords: Coordinates?,
        radius: Int?
    ) async throws -> PlacesResponse
}

final class PlaceService: PlaceServiceProtocol {
    private let api = APIClient.shared
    
    func fetchPlaces(
        location: String,
        pageSize: Int? = 20,
        categories: [String]? = nil
    ) async throws -> PlacesResponse {
        var params: [String: Any] = [
            "location": location,
            "page_size": pageSize ?? 20,
            "fields": "id,title,slug,address,subway,coords,categories,is_closed"
        ]
        
        if let categories = categories {
            params["categories"] = categories.joined(separator: ",")
        }
        
        return try await api.request(
            endpoint: .places,
            parameters: params
        )
    }
    
    func fetchNearbyPlaces(
        location: String,
        coords: Coordinates? = nil,
        radius: Int? = 1000
    ) async throws -> PlacesResponse {
        var params: [String: Any] = [
            "location": location,
            "page_size": 20,
            "fields": "id,title,slug,address,subway,coords,categories,is_closed"
        ]
        
        if let coords = coords {
            params["lat"] = coords.lat
            params["lon"] = coords.lon
            params["radius"] = radius ?? 1000
        }
        
        return try await api.request(
            endpoint: .places,
            parameters: params
        )
    }
}
