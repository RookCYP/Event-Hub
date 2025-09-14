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
    let slug: String?
    let title: String
    let description: String?
    let bodyText: String?
    let ctype: String
    let objectId: Int?
    let itemUrl: String?
    
    // Расширенные поля при expand
    let place: Place?
    let daterange: SearchDateRange?
    let firstImage: FirstImage?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, title, description, ctype, place, daterange
        case objectId = "object_id"
        case bodyText = "body_text"
        case itemUrl = "item_url"
        case firstImage = "first_image"
    }
    
    // Вложенная структура для дат из поиска
    struct SearchDateRange: Codable {
        let startDate: Int?
        let startTime: Int?
        let start: Int?
        let endDate: Int?
        let endTime: Int?
        let end: Int?
        let isContinuous: Bool?
        let isEndless: Bool?
        let isStartless: Bool?
        
        enum CodingKeys: String, CodingKey {
            case start, end
            case startDate = "start_date"
            case startTime = "start_time"
            case endDate = "end_date"
            case endTime = "end_time"
            case isContinuous = "is_continuous"
            case isEndless = "is_endless"
            case isStartless = "is_startless"
        }
    }
    
    struct FirstImage: Codable {
        let image: String?
        let thumbnails: [String: String]?
    }
}
