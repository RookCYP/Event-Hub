//
//  EventCardView.swift
//  Event Hub
//
//  Created by Александр Пеньков on 10.09.2025.
//

import SwiftUI

struct EventCardView: View {
    let image: Image
    let date: String
    let title: String
    let location: String
    let isFavorite: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            HStack(spacing: 18) {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 79, height: 92)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(date)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.Colors.primaryBlue)
                    
                    Text(title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    HStack(spacing: 6) {
                        Image(.Icons.location)
                            .frame(width: 14, height: 14)
                        Text(location)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
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
}

struct EventCardPreview: View {
    var body: some View {
            VStack {
                EventCardView(
                    image: Image("A Virtual Evening of Smooth Jazz"),
                    date: "Sat, May 1 • 2:00 PM",
                    title: "A Virtual Evening of Smooth Jazz",
                    location: "Lot 13 • Oakland, CA",
                    isFavorite: true
                )
            }
            .padding()
        }
}

#Preview {
    EventCardPreview()
}
