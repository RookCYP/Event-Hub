//
//  EventRowView.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 11.09.25.
//

import SwiftUI
import Kingfisher

// EventRowView.swift
struct EventRowView: View {
    let event: Event
    
    // Форматтер для даты
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMM, E, h:mm a"  // "15 янв, Пн, 7:30 PM"
        return formatter
    }()
    
    var body: some View {
        NavigationLink(destination: EventDetailsViewTest(eventId: String(event.id))) {
            HStack(spacing: 12) {
                KFImage(event.primaryImageURL)
                    .placeholder { ProgressView() }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .font(.headline)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    if let firstDate = event.dates.first {
                        Text(formatEventDate(firstDate))
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    if let place = event.place?.title, !place.isEmpty {
                        Text(place)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
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
                return dateFormatter.string(from: date)
            }
            return "Дата не указана"
        }
    }
}
