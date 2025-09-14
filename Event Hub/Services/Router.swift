//
//  Router.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

import Foundation
import SwiftUI


class Router: ObservableObject {
    
    @Published var path = NavigationPath()
    
    func goTo(to route: Routes) {
        path.append(route)
    }
    
    func goBack() {
    
        if path.isEmpty { return }
        path.removeLast()
        
    }
    
    func goToRoot() {
        path.removeLast(path.count)
    }
    
    func popToView(count: Int) {
        path.removeLast(count)
    }
    
    
    
}

enum Routes: Hashable {

    case homeScreen
    case detailScreen
    case seeAllScreen
    case searchScreen
    case createScreen
    case profileScreen
    
}
