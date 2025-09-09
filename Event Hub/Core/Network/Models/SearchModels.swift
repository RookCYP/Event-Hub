//
//  SearchModels.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//

import Foundation
//  /Core/Network/Models/SearchModels.swift
// MARK: - Search Models
struct SearchResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [SearchResult]
}

struct SearchResult: Codable {
    let id: Int
    let title: String
    let description: String?
    let ctype: String
    let objectId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, ctype
        case objectId = "object_id"
    }
}
