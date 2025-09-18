//
//  EventsViewModel.swift
//  Event-Hub
//
//  Created by Aleksandr Zhazhoyan on 17.09.2025.
//

import Foundation

enum EventsTab {
    case upcoming
    case past
}

final class EventsViewModel: ObservableObject {
    @Published var selectedTab: EventsTab = .upcoming
    @Published var upcomingEvents: [Events] = []
    @Published var pastEvents: [Events] = []
    
    var currentEvents: [Events] {
        switch selectedTab {
        case .upcoming:
            return upcomingEvents
        case .past:
            return pastEvents
        }
    }
    
    //Test
    func addTestEvent() {
        let event = Events(title: "Test Event", date: Date())
        upcomingEvents.append(event)
    }
}
