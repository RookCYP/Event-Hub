//
//  Router.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    func navigate(to route: Routes) {
        navigationPath.append(route)
    }
    
    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func goToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    func popToView(count: Int) {
        let popCount = min(count, navigationPath.count)
        navigationPath.removeLast(popCount)
    }
}

enum Routes: Hashable {
   
    // Табы
    case exploreScreen
    case eventsScreen
    case favoritesScreen
    case mapScreen
    case profileScreen
    
    // Навигационные экраны с параметрами
    case eventDetails(eventId: String, eventTitle: String? = nil)
    case editProfile(viewModel: ProfileViewModel)
    case searchScreen(category: String? = nil)
    case seeAllScreen(category: String)
    case notificationScreen
    case listsScreen
    case favoritesSearchScreen
    
    // Для Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .eventDetails(let id, let title):
            hasher.combine("eventDetails")
            hasher.combine(id)
            hasher.combine(title ?? "")
        case .editProfile:
            hasher.combine("editProfile")
        case .searchScreen(let category):
            hasher.combine("searchScreen")
            hasher.combine(category ?? "")
        case .seeAllScreen(let category):
            hasher.combine("seeAllScreen")
            hasher.combine(category)
        case .favoritesSearchScreen:
            hasher.combine("favoritesSearchScreen")
        default:
            hasher.combine(String(describing: self))
        }
    }
    
    static func == (lhs: Routes, rhs: Routes) -> Bool {
            switch (lhs, rhs) {
            case (.eventDetails(let id1, let t1), .eventDetails(let id2, let t2)):
                return id1 == id2 && t1 == t2
            case (.editProfile(let vm1), .editProfile(let vm2)):
                return vm1 === vm2
            case (.searchScreen(let c1), .searchScreen(let c2)):
                return c1 == c2
            case (.seeAllScreen(let c1), .seeAllScreen(let c2)):
                return c1 == c2
            case (.notificationScreen, .notificationScreen),
                 (.listsScreen, .listsScreen),
                 (.favoritesSearchScreen, .favoritesSearchScreen):
                return true
            default:
                return false
            }
        }
}
