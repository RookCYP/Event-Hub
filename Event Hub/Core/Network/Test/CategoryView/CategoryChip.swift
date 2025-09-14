//
//  CategoryChip.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 11.09.25.
//

import SwiftUI

// Обновленный CategoryChip с цветом
struct CategoryChip: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : color)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(isSelected ? color : color.opacity(0.15))
                    )
                
                Text(title)
                    .font(.caption2)
                    .lineLimit(1)
                    .frame(width: 60)
                    .foregroundColor(isSelected ? color : .primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
