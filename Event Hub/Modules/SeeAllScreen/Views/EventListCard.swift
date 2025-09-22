//
//  EventListCard.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 22.09.25.
//


// EventListCard.swift
import SwiftUI
import Kingfisher

struct EventListCard: View {
    let event: Event
    @EnvironmentObject var router: Router
    @State private var loadedImage: Image = Image(systemName: "photo.fill")
    @State private var isFavorite = false
    
    var body: some View {
        Button(action: {
            router.navigate(to: .eventDetails(
                eventId: String(event.id),
                eventTitle: event.title
            ))
        }) {
            EventCardView(
                image: loadedImage,
                date: formattedDate,
                title: event.title,
                location: formattedLocation,
                isFavorite: isFavorite
            )
        }
        .buttonStyle(PlainButtonStyle())
        .task {
            await loadImage()
        }
    }
    
    @MainActor
    private func loadImage() async {
        guard let url = event.primaryImageURL else { return }
        
        do {
            let imageResult = try await KingfisherManager.shared.retrieveImage(with: url)
            loadedImage = Image(uiImage: imageResult.image)
        } catch {
            print("Failed to load image: \(error)")
            // Используем дефолтное изображение
            loadedImage = Image("default_event_image")
        }
    }
    
    private var formattedDate: String {
        guard let firstDate = event.dates.first else { return "Date TBA" }
        
        switch firstDate.dateDisplayType {
        case .permanent:
            return "Постоянная экспозиция"
        case .regular:
            return "По расписанию"
        case .continuous:
            return "Ежедневно"
        case .specific:
            if let date = firstDate.startDateTime {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US")
                formatter.dateFormat = "d MMM"
                return formatter.string(from: date)
            }
            return "Date TBA"
        }
    }
    
    private var formattedLocation: String {
        if let place = event.place {
            return place.title
        }
        return "Location TBA"
    }
}