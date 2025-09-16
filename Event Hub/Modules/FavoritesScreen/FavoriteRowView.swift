//
//  FavoriteRowView.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 16.09.25.
//

import SwiftUI
import Kingfisher

struct FavoriteRowView: View {
    let favorite: FavoriteEvent
    
    var body: some View {
        HStack(spacing: 12) {
            // Изображение с Kingfisher
            if let urlString = favorite.imageURL,
               let url = URL(string: urlString) {
                KFImage(url)
                    .placeholder {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                ProgressView()
                            )
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(favorite.title ?? "Без названия")
                    .font(.headline)
                    .lineLimit(2)
                
                if let place = favorite.placeTitle {
                    Label(place, systemImage: "location")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack {
                    if favorite.isFree {
                        Label("Бесплатно", systemImage: "gift")
                            .font(.caption2)
                            .foregroundColor(.green)
                    } else if let price = favorite.price {
                        Label(price, systemImage: "rublesign.circle")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    if let startDate = favorite.startDate {
                        Text(startDate, style: .date)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
