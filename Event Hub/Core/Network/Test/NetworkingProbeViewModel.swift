//
//  NetworkingProbeViewModel.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//


import Foundation

@MainActor
final class NetworkingProbeViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading = false
    @Published var errorText: String?
    @Published var nextPageURL: URL?

    private let eventService: EventServiceProtocol

    init(eventService: EventServiceProtocol) {
        self.eventService = eventService
    }

    func loadInitial(location: String = "spb") async {
        guard !isLoading else { return }
        isLoading = true
        errorText = nil
        do {
            let now = Date()
            let until = Calendar.current.date(byAdding: .day, value: 7, to: now)!  // +7 дней

            let response = try await eventService.fetchEvents(
                location: location,
                page: 1,                 // <- добавить
                pageSize: 20,
                categories: nil,         // <- добавить
                actualSince: now,
                actualUntil: until
            )
            self.events = response.results
            self.nextPageURL = response.next.flatMap(URL.init(string:))
        } catch {
            self.errorText = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }

    func loadNextPage() async {
        guard let url = nextPageURL, !isLoading else { return }
        isLoading = true
        errorText = nil
        do {
            let response = try await eventService.fetchNextPage(from: url.absoluteString)
            var seen = Set(events.map(\.id))
            var merged = events
            for e in response.results where !seen.contains(e.id) {
                merged.append(e)
                seen.insert(e.id)
            }
            self.events = merged
            self.nextPageURL = response.next.flatMap(URL.init(string:))
        } catch {
            self.errorText = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
        isLoading = false
    }
}
