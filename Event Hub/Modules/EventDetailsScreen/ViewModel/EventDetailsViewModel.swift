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
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    // Данные события из API
    @Published var event: Event?
    
    let eventId: String
    var link: String { "https://youreventhub.app/event/\(eventId)" }
    var message: String { "\(event?.title ?? "Amazing Event") — don't miss it!" }
    
    private let eventService: EventServiceProtocol
    private let favorites: FavoritesServiceProtocol
    
    // Вычисляемые свойства для UI
    var title: String {
        event?.title ?? "Loading..."
    }
    
    var dateTitle: String {
        guard let firstDate = event?.dates.first else { return "Date TBA" }
        return formatDateTitle(firstDate)
    }
    
    var dateSubtitle: String {
        guard let firstDate = event?.dates.first else { return "" }
        return formatDateSubtitle(firstDate)
    }
    
    var placeTitle: String {
        event?.place?.title ?? "Location TBA"
    }
    
    var placeSubtitle: String {
        event?.place?.address ?? ""
    }
    
    var organizerTitle: String {
        // В API KudaGo нет организатора, можно использовать participants
        if let participant = event?.participants?.first {
            return participant.agent?.title ?? "Organizer"
        }
        return "Event Organizer"
    }
    
    var organizerSubtitle: String {
        if let participant = event?.participants?.first {
            return participant.role?.name ?? "Organizer"
        }
        return "Organizer"
    }
    
    var aboutText: String {
        if let description = event?.description {
            return stripHTML(description)
        }
        if let bodyText = event?.bodyText {
            return stripHTML(bodyText)
        }
        return "No description available"
    }
    
    init(eventId: String,
         eventService: EventServiceProtocol = EventService(),
         favorites: FavoritesServiceProtocol = FavoritesService()) {
        self.eventId = eventId
        self.eventService = eventService
        self.favorites = favorites
        
        Task {
            await loadEventDetails()
            await loadFavoriteState()
        }
    }
    
    func loadEventDetails() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let eventDetails = try await eventService.fetchEventDetails(id: eventId)
            self.event = eventDetails
            await loadFavoriteState()
        } catch {
            self.errorMessage = "Failed to load event details: \(error.localizedDescription)"
            print("!!! Failed to load event details: \(error)")
        }
        
        isLoading = false
    }
    
    func toggleFavorite() {
        Task {
            guard let event = event else { return }
            do {
                if isFavorite {
                    try await favorites.removeFromFavorites(eventId: event.id)
                    isFavorite = false
                } else {
                    try await favorites.addToFavorites(event)
                    isFavorite = true
                }
                // оповестим остальные экраны (например, FavoritesView), что список изменился
                NotificationCenter.default.post(name: .favoritesChanged, object: nil)
            } catch {
                print("Favorites error: \(error)")
            }
        }
    }
    
    private func loadFavoriteState() async {
        // Берём id из event если есть, иначе пробуем распарсить из eventId:String
        let numericId: Int? = event?.id ?? Int(eventId)
        guard let id = numericId else {
            // если id строковый и не приводится к Int, пропускаем Core Data проверку
            self.isFavorite = false
            return
        }
        let fav = await favorites.isFavorite(eventId: id)
        self.isFavorite = fav
    }
    
    private func saveFavoriteState() {
        // TODO: Сохранить в Core Data
        guard let event = event else { return }
        
        if isFavorite {
            // Добавить в избранное
            print("Adding event \(event.id) to favorites")
        } else {
            // Удалить из избранного
            print("Removing event \(event.id) from favorites")
        }
    }
    
    var shareTargets: [ShareTarget] {
        [
            .copyLink,
            .whatsapp, .telegram, .facebook, .messenger,
            .twitter, .instagram, .iMessage
        ]
    }
    
    // MARK: - Formatting Helpers
    
    private func formatDateTitle(_ eventDate: EventDate) -> String {
        switch eventDate.dateDisplayType {
        case .permanent:
            return "Permanent Exhibition"
        case .regular:
            return "By Schedule"
        case .continuous:
            return "Daily"
        case .specific:
            if let date = eventDate.startDateTime {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US")
                formatter.dateFormat = "d MMMM yyyy"
                return formatter.string(from: date)
            }
            return "Date TBA"
        }
    }
    
    private func formatDateSubtitle(_ eventDate: EventDate) -> String {
        switch eventDate.dateDisplayType {
        case .specific:
            if let startDate = eventDate.startDateTime,
               let endDate = eventDate.endDateTime {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US")
                formatter.dateFormat = "EEEE, h:mm a"
                
                let startTime = formatter.string(from: startDate)
                formatter.dateFormat = "h:mm a"
                let endTime = formatter.string(from: endDate)
                
                return "\(startTime) - \(endTime)"
            } else if let date = eventDate.startDateTime {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US")
                formatter.dateFormat = "EEEE, h:mm a"
                return formatter.string(from: date)
            }
        case .continuous:
            return "Open daily"
        case .regular:
            return "Check schedule"
        case .permanent:
            return "Always available"
        }
        return ""
    }
    
    private func stripHTML(_ html: String) -> String {
        html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}

extension Notification.Name {
    static let favoritesChanged = Notification.Name("favoritesChanged")
}
