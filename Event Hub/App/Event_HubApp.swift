//
//  Event_HubApp.swift
//  Event Hub
//
//  Created by Rook on 07.09.2025.
//

import SwiftUI

@main
struct Event_HubApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
