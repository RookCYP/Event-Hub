//
//  CategoryScrollView.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 11.09.25.
//

import SwiftUI

struct CategoryScrollView: View {
    let categories: [Category]
    @Binding var selectedCategory: String?
    let onCategorySelected: (String?) async -> Void
    
    // Иконки и цвета для категорий (добавляем вручную)
    private let categoryConfig: [String: (icon: String, color: Color)] = [
        "concert": ("music.note", .purple),
        "exhibition": ("paintbrush", .orange),
        "festival": ("sparkles", .pink),
        "theater": ("theatermasks", .red),
        "cinema": ("film", .indigo),
        "education": ("graduationcap", .blue),
        "tour": ("map", .green),
        "party": ("party.popper", .purple),
        "kids": ("figure.2.and.child.holdinghands", .cyan),
        "sport": ("sportscourt", .orange),
        "quest": ("puzzlepiece", .yellow),
        "stand-up": ("mic", .red),
        "business-events": ("briefcase", .gray),
        "food": ("fork.knife", .orange),
        "fashion": ("sparkle", .pink),
        "holiday": ("gift", .red),
        "entertainment": ("gamecontroller", .blue),
        "photo": ("camera", .gray),
        "recreation": ("leaf", .green),
        "shopping": ("bag", .purple),
        "social-activity": ("heart", .pink),
        "stock": ("tag", .orange),
        "yarmarki-razvlecheniya-yarmarki": ("tent", .brown),
        "other": ("ellipsis.circle", .gray)
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Кнопка "Все"
                CategoryChip(
                    title: "Все",
                    icon: "square.grid.2x2",
                    color: .blue,
                    isSelected: selectedCategory == nil,
                    action: {
                        selectedCategory = nil
                        Task {
                            await onCategorySelected(nil)
                        }
                    }
                )
                
                // Категории из API
                ForEach(categories, id: \.slug) { category in
                    let config = categoryConfig[category.slug] ?? ("tag", .gray)
                    CategoryChip(
                        title: category.name,
                        icon: config.icon,
                        color: config.color,
                        isSelected: selectedCategory == category.slug,
                        action: {
                            selectedCategory = category.slug
                            Task {
                                await onCategorySelected(category.slug)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}
