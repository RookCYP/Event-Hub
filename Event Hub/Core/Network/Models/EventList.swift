//
//  EventList.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 14.09.25.
//

import Foundation

struct EventList: Codable, Identifiable {
    let id: Int
    let title: String
    let slug: String?
    let description: String?
    let bodyText: String?
    let publicationDate: Int?
    let images: [EventImage]?
    let placeCount: Int?
    let itemCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, slug, description, images
        case bodyText = "body_text"
        case publicationDate = "publication_date"
        case placeCount = "place_count"
        case itemCount = "item_count"
    }
    
    var webViewURL: URL? {
        guard let slug = slug else { return nil }
        return URL(string: "https://kudago.com/\(slug)/")
    }
}

struct ListsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [EventList]
}
