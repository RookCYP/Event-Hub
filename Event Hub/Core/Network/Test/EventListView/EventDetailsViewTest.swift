//
//  EventDetailsViewTest.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 13.09.25.
//

// EventDetailsViewTest.swift
import SwiftUI
import Kingfisher

struct EventDetailsViewTest: View {
    let eventId: String
    @State private var event: Event?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    private let eventService = EventService()
    
    var body: some View {
        ScrollView {
            if let event = event {
                VStack(alignment: .leading, spacing: 16) {
                    // Главное изображение
                    if let imageURL = event.primaryImageURL {
                        KFImage(imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Заголовок и цена
                        Text(event.title)
                            .font(.largeTitle)
                            .bold()
                        
                        HStack {
                            if event.isFree == true {
                                Label("Бесплатно", systemImage: "gift")
                                    .foregroundColor(.green)
                            } else if let price = event.price, !price.isEmpty {
                                Label(price, systemImage: "rublesign.circle")
                                    .foregroundColor(.blue)
                            }
                            
                            Spacer()
                            
                            if let ageRestriction = event.ageRestriction?.text, !ageRestriction.isEmpty {
                                Text(ageRestriction)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.red.opacity(0.1))
                                    .foregroundColor(.red)
                                    .cornerRadius(4)
                            }
                        }
                        
                        // Дата и место
                        if let firstDate = event.dates.first {
                            Label(formatEventDate(firstDate), systemImage: "calendar")
                                .foregroundColor(.secondary)
                        }
                        
                        if let place = event.place {
                            VStack(alignment: .leading, spacing: 4) {
                                Label(place.title, systemImage: "location")
                                    .font(.headline)
                                if let address = place.address, !address.isEmpty {
                                    Text(address)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 24)
                                }
                            }
                        }
                        
                        // Описание
                        if let description = event.description {
                            Text("Описание")
                                .font(.headline)
                                .padding(.top)
                            
                            Text(stripHTML(description))
                                .font(.body)
                        }
                        
                        // Подробности
                        if let bodyText = event.bodyText {
                            Text("Подробности")
                                .font(.headline)
                                .padding(.top)
                            
                            Text(stripHTML(bodyText))
                                .font(.body)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if isLoading {
                ProgressView("Загрузка...")
            }
            if let error = errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text(error)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
        .task {
            await loadEventDetails()
        }
    }
    
    private func loadEventDetails() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let details = try await eventService.fetchEventDetails(id: eventId)
            self.event = details
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func formatEventDate(_ eventDate: EventDate) -> String {
        switch eventDate.dateDisplayType {
        case .permanent:
            return "Постоянная экспозиция"
        case .regular:
            return "По расписанию"
        case .continuous:
            return "Ежедневно"
        case .specific:
            if let date = eventDate.startDateTime {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ru_RU")
                formatter.dateStyle = .long
                formatter.timeStyle = .short
                return formatter.string(from: date)
            }
            return "Дата не указана"
        }
    }
    
    private func stripHTML(_ html: String) -> String {
        html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
