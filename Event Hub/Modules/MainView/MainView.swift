//
//  MainView.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authManager: AuthenticationManager
    
    @StateObject private var router = Router()
    @State private var selectedTab: TabEnum = .explore

    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    ExploreView()
                        .tag(TabEnum.explore)
                    
                    EventsView()
                        .tag(TabEnum.events)
                    
                    FavoritesView()
                        .tag(TabEnum.favorites)
                    
                    MapView()
                        .tag(TabEnum.map)
                    
                    ProfileView()
                        .tag(TabEnum.profile)
                }
                .padding(.top, selectedTab.title.isEmpty ? 0 : 50)
                .environment(\.managedObjectContext, viewContext)
                
                if !selectedTab.title.isEmpty {
                    VStack {
                        CustomNavBar(
                            title: selectedTab.title,
                            showSearchButton: selectedTab == .favorites,
                            onSearchTap: {
                                router.navigate(to: .searchScreen(category: "favorites"))
                            }
                        )
                        Spacer()
                    }
                }
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard)
            .navigationDestination(for: Routes.self) { route in
                destinationView(for: route)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tint(.black)
        .environmentObject(router)

    }
    
    @ViewBuilder
        private func destinationView(for route: Routes) -> some View {
            switch route {
            case .eventDetails(let eventId, let eventTitle):
                EventDetailsView(eventId: eventId, eventTitle: eventTitle)
                    .navigationBarHidden(true)
                
            case .editProfile(let viewModel):
                EditProfileView(viewModel: viewModel)
                    .navigationBarHidden(false)
                
            case .searchScreen(let category):
                SearchView()
                    .navigationBarHidden(false)
                    .onAppear {
                        // Можно передать category через @EnvironmentObject или другим способом
                        print("Search category: \(category ?? "all")")
                    }
                
            case .seeAllScreen(let category):
                SeeAllView(category: category)
                    .navigationBarHidden(false)
                    .onAppear {
                        print("See all category: \(category)")
                    }
                
            case .notificationScreen:
                NotificationView()
                    .navigationBarHidden(false)
                
            case .listsScreen:
                ListsView()
                    .navigationBarHidden(false)
                
            case .favoritesSearchScreen:
                FavoritesSearchView()
                    .navigationBarHidden(false)
                
            case .exploreScreen, .eventsScreen, .favoritesScreen, .mapScreen, .profileScreen:
                EmptyView()
            }
        }
}

#Preview {
    MainView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AuthenticationManager())
}
