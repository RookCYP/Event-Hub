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
        NavigationView {
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
                                // Отправляем уведомление
                                NotificationCenter.default.post(
                                    name: .openFavoritesSearch,
                                    object: nil
                                )
                            }
                        )
                        Spacer()
                    }
                }
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard)
            // Убираем .sheet
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tint(.black)
        .environmentObject(router)
        .fullScreenCover(isPresented: $router.isPresented) {
            if let route = router.currentRoute {
                destinationView(for: route)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: Routes) -> some View {
        NavigationView {
            switch route {
            case .exploreScreen:
                ExploreView()
            case .eventsScreen:
                EventsView()
            case .favoritesScreen:
                FavoritesView()
            case .mapScreen:
                MapView()
            case .profileScreen:
                ProfileView()
            case .detailScreen:
                DetailView()
            case .notificationScreen:
                NotificationView()
            case .searchScreen:
                SearchView()
            case .listsScreen:
                ListsView()
            case .seeAllScreen:
                SeeAllView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MainView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AuthenticationManager())
}
