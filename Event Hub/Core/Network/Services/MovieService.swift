//
//  MovieService.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 14.09.25.
//


// MovieService.swift
import Foundation

protocol MovieServiceProtocol {
    func fetchMovies(
        location: String,
        page: Int,
        pageSize: Int
    ) async throws -> MoviesResponse
    
    func fetchMovieDetails(id: String) async throws -> Movie
    func fetchNextPage(from urlString: String) async throws -> MoviesResponse
}

final class MovieService: MovieServiceProtocol {
    private let api = APIClient.shared
    
    func fetchMovies(
        location: String,
        page: Int = 1,
        pageSize: Int = 20
    ) async throws -> MoviesResponse {
        return try await api.request(
            endpoint: .movies,
            parameters: [
                "location": location,
                "page": page,
                "page_size": pageSize,
                "fields": "id,title,slug,poster,genres,year,country,director,trailer,age_restriction",
                "expand": "poster"
            ]
        )
    }
    
    func fetchMovieDetails(id: String) async throws -> Movie {
        return try await api.request(
            endpoint: .movieDetails(id: id),
            parameters: [
                "fields": "id,title,body_text,description,genres,year,country,director,cast,trailer,images,age_restriction,running_time,poster",
                "expand": "images,poster"
            ]
        )
    }
    
    func fetchNextPage(from urlString: String) async throws -> MoviesResponse {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        return try await api.request(url: url)
    }
}
