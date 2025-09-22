//
//  ExploreView.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var router: Router
    @State private var searchText = ""
    
    // TODO: заменить временные моковые данные на реальные
    let upcomingEvents = [
        (id: "1", date: "10 June", title: "A Virtual Evening of Smooth Jazz", location: "Lot 13 • Oakland, CA"),
        (id: "2", date: "15 June", title: "International Band Music Concert", location: "Madison Square • NY"),
        // ...  больше событий
    ]
    
    let nearbyEvents = [
        (id: "11", date: "12 June", title: "Local Art Exhibition", location: "Gallery 5 • Brooklyn, NY"),
        (id: "12", date: "18 June", title: "Food Festival", location: "Central Park • NY"),
        // ...  больше событий
    ]
    
    var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Верхняя синяя секция
                    ExploreHeaderSection()
                    
                    // Upcoming Events секция
                    EventsSection(
                        title: "Upcoming Events",
                        events: upcomingEvents,
                        seeAllCategory: "upcoming"
                    )
                    .padding(.top, 16)
                    
                    // Nearby You секция
                    EventsSection(
                        title: "Nearby You",
                        events: nearbyEvents,
                        seeAllCategory: "nearby"
                    )
                    .padding(.top, 24)
                    .padding(.bottom, 100)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
}

struct CategoryButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(color)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
}

// Хедер как отдельный компонент
struct ExploreHeaderSection: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            // Фоновый слой
            Color.blue
                .clipShape(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .offset(y: -44)
                )
                .ignoresSafeArea(edges: .top)
            
            // Контент
            VStack(alignment: .leading, spacing: 24) {
                // Location и Notifications с отступами
                LocationNotificationBar()
                    .padding(.horizontal)
                
                // Search и Filters с отступами
                SearchFilterBar()
                    .padding(.horizontal)
                
                // Категории без отступов - на всю ширину
                CategoriesSection()
            }
            .padding(.top, 60)
            .padding(.bottom, 24)
        }
    }
}

// Локация и уведомления
struct LocationNotificationBar: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Location")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white)
                Text("New York, USA")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                router.navigate(to: .notificationScreen)
            }) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 44, height: 44)
                    Image(systemName: "bell.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 20, weight: .semibold))
                }
            }
        }
    }
}

// Поиск и фильтры
struct SearchFilterBar: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                router.navigate(to: .searchScreen(category: nil))
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    Text("Search...")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(Color(.systemGray6))
                .cornerRadius(16)
            }
            
            Button(action: {
                // TODO: Добавить route для фильтров
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "slider.horizontal.3")
                    Text("Filters")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
    }
}

// Секция с событиями (переиспользуемая)
struct EventsSection: View {
    @EnvironmentObject var router: Router
    
    let title: String
    let events: [(id: String, date: String, title: String, location: String)]
    let seeAllCategory: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    router.navigate(to: .seeAllScreen(category: seeAllCategory))
                }) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(events, id: \.id) { event in
                        EventBigCardView(
                            eventId: event.id,
                            image: Image("International Band Mu"),
                            date: event.date,
                            title: event.title,
                            location: event.location,
                            isFavorite: seeAllCategory == "upcoming"
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct CategoriesSection: View {
    @EnvironmentObject var router: Router
    
    let categories: [(icon: String, title: String, color: Color)] = [
        ("sportscourt", "Sports", .green),
        ("music.note", "Music", .purple),
        ("fork.knife", "Food", .orange),
        ("paintbrush", "Art", .pink),
        ("book", "Education", .blue)
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.title) { category in
                    CategoryButton(
                        icon: category.icon,
                        title: category.title,
                        color: category.color
                    ) {
                        router.navigate(to: .searchScreen(
                            category: category.title.lowercased()
                        ))
                    }
                }
            }
            .padding(.horizontal) // Отступы только для контента внутри ScrollView
        }
    }
}

#Preview {
    ExploreView()
}
