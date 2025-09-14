//
//  MainView.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var router = Router()
    @State private var selectedTab: TabEnum = .home
    
    var body: some View {
        
        NavigationView {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    ExploreView()
                        .tag(TabEnum.home)
                        .toolbar(.hidden, for: .tabBar)
                        
                    EventsView()
                        .tag(TabEnum.bookmarks)
                        .toolbar(.hidden, for: .tabBar)
                        
                    FavoritesView()
                        .tag(TabEnum.add)
                        .toolbar(.hidden, for: .tabBar)
                        
                    MapView()
                        .tag(TabEnum.notifications)
                        .toolbar(.hidden, for: .tabBar)
                        
                    ProfileView()
                        .tag(TabEnum.profile)
                        .toolbar(.hidden, for: .tabBar)
                }
                .padding(.top, selectedTab.title.isEmpty ? 0 : 50)
                
                if !selectedTab.title.isEmpty {
                    VStack {
                        CustomNavBar(title: selectedTab.title)
                        Spacer()
                    }
                }
                
                CustomTabBar(selectedTab: $selectedTab)
            }
            
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .tint(.black)
        .environmentObject(router)
        .sheet(isPresented: $router.isPresented) {
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
                // Здесь нужно будет добавить DetailView когда он будет создан
                Text("Detail Screen")
                    .navigationTitle("Detail")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Назад") {
                                router.goBack()
                            }
                        }
                    }
            case .favoritesScreen:
                // Здесь нужно будет добавить SeeAllView когда он будет создан
                Text("See All Screen")
                    .navigationTitle("See All")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Назад") {
                                router.goBack()
                            }
                        }
                    }
            case .searchScreen:
                // Здесь нужно будет добавить SearchScreenView когда он будет создан
                Text("Search Screen")
                    .navigationTitle("Поиск")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Назад") {
                                router.goBack()
                            }
                        }
                    }
//            case .createScreen:
//                AddRecipeView()
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarLeading) {
//                            Button("Назад") {
//                                router.goBack()
//                            }
//                        }
//                    }
            case .profileScreen:
                ProfileView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Назад") {
                                router.goBack()
                            }
                        }
                    }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MainView()
}
