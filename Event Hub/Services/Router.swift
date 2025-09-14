//
//  Router.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    
    @Published var currentRoute: Routes? = nil
    @Published var isPresented = false
    
    func goTo(to route: Routes) {
        currentRoute = route
        isPresented = true
    }
    
    func goBack() {
        isPresented = false
        currentRoute = nil
    }
    
    func goToRoot() {
        isPresented = false
        currentRoute = nil
    }
    
    func popToView(count: Int) {
        // Для iOS 15 это будет простое возвращение
        goBack()
    }
}

enum Routes: Hashable {
    case exploreScreen
    case eventsScreen
    case favoritesScreen
    case mapScreen
    case profileScreen
    case detailScreen
    case notificationScreen
    case searchScreen
    case listsScreen
    case seeAllScreen
}
