//
//  EventBigCardView.swift
//  Event Hub
//
//  Created by Александр Пеньков on 15.09.2025.
//

import SwiftUI

struct EventBigCardView<Content: View>: View {
    let eventId: String
    @ViewBuilder let imageContent: () -> Content
    let date: String
    let title: String
    let location: String
    let isFavorite: Bool
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        Button(action: {
            router.navigate(to: .eventDetails(
                eventId: eventId,
                eventTitle: title
            ))
        }) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 18) {
                    imageContent()
                        .resizableIfPossible()
                        .scaledToFill()
                        .frame(width: 218, height: 131)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(date)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.Colors.primaryBlue)
                        
                        Text(title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 6) {
                            Image(.Icons.location)
                                .frame(width: 14, height: 14)
                            Text(location)
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
                
                if isFavorite {
                    Image(.Icons.bookmark)
                        .padding(8)
                }
            }
        }
        .buttonStyle(PlainButtonStyle()) // Убираем стандартный стиль кнопки
    }
}

// A small helper to call resizable() when the content is an Image or AsyncImage,
// while leaving other views untouched.
private extension View {
    @ViewBuilder
    func resizableIfPossible() -> some View {
        if let image = self as? Image {
            image.resizable()
        } else if let asyncType = Self.self as? Any.Type, String(describing: asyncType).contains("AsyncImage") {
            // AsyncImage already handles content sizing via its own closure; return as-is
            self
        } else {
            self
        }
    }
}

struct EventBigCardViewPreview: View {
    var body: some View {
        VStack {
            EventBigCardView(
                eventId: "123",
                imageContent: {
                    Image("International Band Mu")
                },
                date: "10 June",
                title: "A Virtual Evening of Smooth Jazz",
                location: "Lot 13 • Oakland, CA",
                isFavorite: true
            )
        }
        .padding()
    }
}

#Preview {
    EventBigCardViewPreview()
}

