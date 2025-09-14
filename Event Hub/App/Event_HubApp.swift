//
//  Event_HubApp.swift
//  Event Hub
//
//  Created by Rook on 07.09.2025.
//

import SwiftUI
import Firebase

@main
struct Event_HubApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var authManager = AuthenticationManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                MainView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(authManager)
            } else {
                AuthenticationView()
                    .environmentObject(authManager)
            }
        }
    }
}
