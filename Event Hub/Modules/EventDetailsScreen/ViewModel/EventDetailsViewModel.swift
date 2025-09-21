//
//  EventDetailsViewModel.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/19/25.
//

import Foundation

@MainActor
final class EventDetailsViewModel: ObservableObject {
    @Published var showShareSheet = false
    @Published var isFavorite = false
    
    let eventId: String
    let link: String
    let message: String
    
    // Загружаем по eventId
    @Published var title = "International Band Music Concert"
    @Published var dateTitle = "14 December 2021"
    @Published var dateSubtitle = "Tuesday, 4:00 pm - 9:00 pm"
    @Published var placeTitle = "Gala Convention Centre"
    @Published var placeSubtitle = "36 Guild Street London, UK"
    @Published var organizerTitle = "Ashfak Sayem"
    @Published var organizerSubtitle = "Organizer"
    @Published var aboutText = """
    Discover events you’ll love and make every day unforgettable. Plan your perfect schedule with just a few taps, explore exciting activities happening near you, and connect with the moments that matter most. Stay inspired, stay informed, and never miss what’s happening around you!
    """
    
    init(eventId: String, link: String, message: String) {
        self.eventId = eventId
        self.link = link
        self.message = message
        
        // Здесь можно загрузить данные по eventId
        Task {
            await loadEventDetails()
            await loadFavoriteState()
        }
    }
    
    private func loadEventDetails() async {
        // Загрузка данных с сервера или из Core Data
        // Пока используем моковые данные
    }
    func toggleFavorite() {
        isFavorite.toggle()
        saveFavoriteState()
    }
    
    private func loadFavoriteState() async {
        
        
    }
    
    private func saveFavoriteState() {
        
    }
    
    var shareTargets: [ShareTarget] {
        [
            .copyLink,
            .whatsapp, .telegram, .facebook, .messenger,
            .twitter, .instagram, .iMessage
        ]
    }
}
