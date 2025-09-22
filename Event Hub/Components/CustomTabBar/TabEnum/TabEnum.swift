//
//  TabEnum.swift
//  BestRecipes
//
//  Created by Drolllted on 11.08.2025.
//

import SwiftUI


enum TabEnum: Int, CaseIterable {
    case explore, events, favorites, map, profile
    
    var icon: String {
        switch self {
        case .explore: return "exploreIconForTabBar"
        case .events: return "eventsIconForTabBar"
        case .favorites: return "favoritesIconForTabBar"
        case .map: return "mapIconForTabBar"
        case .profile: return "profileIconForTabBar"
        }
    }
    
    var title: String {
        switch self {
        case .explore:
            return ""  // Пустая строка - не показываем NavBar
        case .events:
            return "Events"
        case .favorites:
            return "Favorites"
        case .map:
            return "Map"
        case .profile:
            return "My profile"
        }
    }
}
