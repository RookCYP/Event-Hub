//
//  SeeAllViewModel.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 22.09.25.
//

// SeeAllViewModel.swift
import Foundation

@MainActor
final class SeeAllViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var nextPageURL: URL?
    
    private let category: String
    private let eventService: EventServiceProtocol
    private var currentLocation = "spb"
    
    init(category: String, eventService: EventServiceProtocol = EventService()) {
        self.category = category
        self.eventService = eventService
    }
    
    func loadInitial() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let response: EventsResponse
            
            switch category {
            case "upcoming":
                // Предстоящие события на неделю
                response = try await eventService.fetchEvents(
                    location: currentLocation,
                    dateRange: .next7Days,
                    page: 1,
                    pageSize: 20,
                    categories: nil
                )
                
            case "nearby":
                // События рядом на сегодня/неделю
                response = try await eventService.fetchEvents(
                    location: currentLocation,
                    dateRange: .next7Days,  // или .today для только сегодняшних
                    page: 1,
                    pageSize: 20,
                    categories: nil
                )
                
            case "sports", "music", "food", "art", "education":
                // События по категории на месяц
                response = try await eventService.fetchEvents(
                    location: currentLocation,
                    dateRange: .thisMonth,  // Используем существующий thisMonth
                    page: 1,
                    pageSize: 20,
                    categories: [category]
                )
                
            default:
                // Все события на текущий месяц
                response = try await eventService.fetchEvents(
                    location: currentLocation,
                    dateRange: .thisMonth,
                    page: 1,
                    pageSize: 20,
                    categories: nil
                )
            }
            
            self.events = response.results
            self.nextPageURL = response.next.flatMap(URL.init(string:))
            
        } catch {
            print("❌ Failed to load events: \(error)")
        }
        
        isLoading = false
    }
    
    func loadNextPage() async {
        guard let url = nextPageURL, !isLoading else { return }
        isLoading = true
        
        do {
            let response = try await eventService.fetchNextPage(from: url.absoluteString)
            
            var seenIds = Set(events.map(\.id))
            var mergedEvents = events
            
            for event in response.results where !seenIds.contains(event.id) {
                mergedEvents.append(event)
                seenIds.insert(event.id)
            }
            
            self.events = mergedEvents
            self.nextPageURL = response.next.flatMap(URL.init(string:))
            
        } catch {
            print("❌ Failed to load next page: \(error)")
        }
        
        isLoading = false
    }
}
