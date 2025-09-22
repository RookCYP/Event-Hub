//
//  APIEndpoint.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 08.09.25.
//

//  /Core/Network/APIEndpoint.swift

// MARK: - APIEndpoint
enum APIEndpoint {
    case locations
    case events
    case eventDetails(id: String)
    case categories
    case places
    case search
    case movies
    case movieDetails(id: String)
    case lists
    case listDetails(id: String)
    
    var path: String {
        switch self {
        case .locations:       return "/locations/"
        case .events:          return "/events/"
        case .eventDetails(let id): return "/events/\(id)/"
        case .categories:      return "/event-categories/"
        case .places:          return "/places/"
        case .search:          return "/search/"  // KudaGo search endpoint чтобы дёргать /search/?q=
        case .movies:           return "/movies/"
        case .movieDetails(let id): return "/movies/\(id)/"
        case .lists: return "/lists/"
        case .listDetails(let id): return "/lists/\(id)/"
        }
    }
}
