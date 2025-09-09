//
//  CoreModels.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 08.09.25.
//

import Foundation

//  /Core/Network/Models/CoreModels.swift
// MARK: - Core Models
struct Event: Codable, Identifiable {
    let id: Int
    let publicationDate: Int?
    let dates: [EventDate]
    let title: String
    let shortTitle: String?
    let slug: String?
    let place: Place?
    let description: String?
    let bodyText: String?
    let location: LocationField?
    let categories: [String]?
    let tagline: String?
    let ageRestriction: StringOrInt?
    let price: String?
    let isFree: Bool?
    let images: [EventImage]?
    let favoritesCount: Int?
    let commentsCount: Int?
    let siteUrl: String?
    let tags: [String]?
    let participants: [Participant]?
    
    enum CodingKeys: String, CodingKey {
        case id, dates, title, slug, place, description, location, categories, tagline, price, images, tags, participants
        case publicationDate = "publication_date"
        case shortTitle = "short_title"
        case bodyText = "body_text"
        case ageRestriction = "age_restriction"
        case isFree = "is_free"
        case favoritesCount = "favorites_count"
        case commentsCount = "comments_count"
        case siteUrl = "site_url"
    }
}

extension Event {
    var primaryImageURL: URL? {
        guard let urlStr = images?.first?.image else { return nil }
        return URL(string: urlStr)
    }
}

extension Event {
    var ageRestrictionText: String {
        ageRestriction?.text ?? ""
    }
}

struct EventDate: Codable {
    let start: Int?
    let end: Int?
    let startDate: String?
    let startTime: String?
    let endDate: String?
    let endTime: String?
    let isRegular: Bool?
    let isEndless: Bool?
    
    enum CodingKeys: String, CodingKey {
        case start, end
        case startDate = "start_date"
        case startTime = "start_time"
        case endDate = "end_date"
        case endTime = "end_time"
        case isRegular = "is_regular"
        case isEndless = "is_endless"
    }
    
    // Computed property for SwiftUI
    var startDateTime: Date? {
        guard let start = start else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(start))
    }
    
    var endDateTime: Date? {
        guard let end = end else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(end))
    }
}

struct Location: Codable, Identifiable {
    var id: String { slug }
    let slug: String
    let name: String
    let timezone: String?
    let coords: Coordinates?
    let language: String?
    let currency: String?
    
    enum CodingKeys: String, CodingKey {
        case slug, name, timezone, coords, language, currency
    }
}

struct Coordinates: Codable {
    let lat: Double?
    let lon: Double?

    enum CodingKeys: String, CodingKey { case lat, lon }

    init(lat: Double?, lon: Double?) {
        self.lat = lat; self.lon = lon
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        // Поддержим числа, строки и null
        func decodeDouble(for key: CodingKeys) -> Double? {
            if let d = try? c.decodeIfPresent(Double.self, forKey: key) { return d }
            if let s = try? c.decodeIfPresent(String.self, forKey: key) { return Double(s) }
            return nil
        }
        self.lat = decodeDouble(for: .lat)
        self.lon = decodeDouble(for: .lon)
    }
}

struct Place: Codable, Identifiable {
    let id: Int
    let title: String
    let slug: String?
    let address: String?
    let phone: String?
    let subway: String?
    let location: String?
    let siteUrl: String?
    let foreignUrl: String?
    let coords: Coordinates?
    let isClosed: Bool?
    let categories: [String]?
    let shortTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, slug, address, phone, subway, location, coords, categories
        case siteUrl = "site_url"
        case foreignUrl = "foreign_url"
        case isClosed = "is_closed"
        case shortTitle = "short_title"
    }
}

struct EventImage: Codable {
    let image: String
    let source: Source?
    
    struct Source: Codable {
        let name: String?
        let link: String?
    }
}

struct Category: Codable, Identifiable {
    let id: Int
    let slug: String
    let name: String
}

struct Participant: Codable {
    let role: Role?
    let agent: Agent?

    struct Role: Codable {
        let id: Int?
        let name: String?
        let namePlural: String?

        enum CodingKeys: String, CodingKey {
            case id, name
            case namePlural = "name_plural"
        }
    }

    struct Agent: Codable {
        let id: Int?
        let title: String?
        let slug: String?
        let siteUrl: String?
        let images: [EventImage]?
        let agentType: String?

        enum CodingKeys: String, CodingKey {
            case id, title, slug, images
            case siteUrl = "site_url"
            case agentType = "agent_type"
        }
    }
}
