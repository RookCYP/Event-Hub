//
//  Movie.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 14.09.25.
//

//  /Core/Network/Models/MovieModels.swift
struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let slug: String?
    let poster: MoviePoster?
    let genres: [String]?
    let year: Int?
    let country: String?
    let director: String?
    let cast: String?
    let trailer: String?
    let runningTime: Int?
    let ageRestriction: String?
    let bodyText: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, slug, poster, genres, year, country, director, cast, trailer, description
        case runningTime = "running_time"
        case ageRestriction = "age_restriction"
        case bodyText = "body_text"
    }
}

struct MoviePoster: Codable {
    let image: String?
    let thumbnails: [String: String]?
}

struct MoviesResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Movie]
}
