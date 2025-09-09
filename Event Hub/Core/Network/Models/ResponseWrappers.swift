//
//  ResponseWrappers.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 08.09.25.
//

import Foundation

//  /Core/Network/Models/ResponseWrappers.swift
// MARK: - Response Wrappers
struct EventsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Event]
}

struct LocationsResponse: Codable {
    let results: [Location]
}

struct CategoriesResponse: Codable {
    let results: [Category]
}
