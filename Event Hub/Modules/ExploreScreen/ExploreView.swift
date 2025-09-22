//
//  ExploreView.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

import SwiftUI

// MARK: - ViewModel для ExploreView
final class ExploreViewModel: ObservableObject {
    @Published var upcomingEvents: [Event] = []
    @Published var nearbyEvents: [Event] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    private let eventService: EventServiceProtocol
    private var currentLocation: String = "msk" // Было "moscow" — для KudaGo нужен slug "msk"
    
    init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
    }
    
    @MainActor
    func loadEvents() async {
        isLoading = true
        error = nil
        do {
            // Для примера: загружаем две категории одинаково, но можно фильтровать иначе
            let upcoming = try await eventService.fetchEvents(
                location: currentLocation,
                dateRange: nil,
                page: 1,
                pageSize: 10,
                categories: nil
            )
            self.upcomingEvents = upcoming.results ?? []
            
            let nearby = try await eventService.fetchEvents(
                location: currentLocation,
                dateRange: nil,
                page: 2,
                pageSize: 10,
                categories: nil
            )
            self.nearbyEvents = nearby.results ?? []
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}

// MARK: - Основное View
struct ExploreView: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = ExploreViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // Верхняя синяя секция
                ExploreHeaderSection()
                
                if viewModel.isLoading {
                    ProgressView("Loading events...")
                        .padding()
                } else if let error = viewModel.error {
                    VStack(spacing: 8) {
                        Text("Ошибка загрузки событий:")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                        Button("Попробовать снова") {
                            Task { await viewModel.loadEvents() }
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                } else {
                    // Upcoming Events секция
                    EventsSection(
                        title: "Upcoming Events",
                        events: viewModel.upcomingEvents,
                        seeAllCategory: "upcoming"
                    )
                    .padding(.top, 16)
                    
                    // Nearby You секция
                    EventsSection(
                        title: "Nearby You",
                        events: viewModel.nearbyEvents,
                        seeAllCategory: "nearby"
                    )
                    .padding(.top, 24)
                    .padding(.bottom, 100)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .task {
            await viewModel.loadEvents()
        }
    }
}

// Категории, LocationNotificationBar, SearchFilterBar, CategoryButton, EventsSection — БЕЗ ИЗМЕНЕНИЙ кроме EventsSection

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
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Location")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white)
                
                Text(locationManager.currentLocation)
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
        .onAppear {
            // Запрашиваем разрешение через публичный метод менеджера
            locationManager.requestAuthorization()
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
    let events: [Event]
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
                    ForEach(events) { event in
                        EventBigCardView(
                            eventId: String(event.id),
                            imageContent: {
                                if let url = event.primaryImageURL {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                    }
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                }
                            },
                            date: event.dates.first?.displayText ?? "",
                            title: event.title,
                            location: event.place?.address ?? "—",
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
