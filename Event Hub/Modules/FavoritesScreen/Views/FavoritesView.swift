//
//  FavoritesView.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

// /Modules/Favorites/Views/FavoritesView.swift
import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var showingDeleteAlert = false
    @State private var eventToDelete: FavoriteEvent?
    @State private var navigateToSearch = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Скрытый NavigationLink для программной навигации
                NavigationLink(
                    destination: FavoritesSearchView(),
                    isActive: $navigateToSearch
                ) {
                    EmptyView()
                }
                .hidden()
                
                if viewModel.isLoading {
                    ProgressView("Loading favorites...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.favorites.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
            }
            .navigationBarHidden(true)
            .task {
                await viewModel.loadFavorites()
            }
            .refreshable {
                await viewModel.loadFavorites()
            }
            .alert("Remove from favorites?", isPresented: $showingDeleteAlert) {
                Button("Remove", role: .destructive) {
                    if let event = eventToDelete {
                        Task {
                            await viewModel.removeFromFavorites(event)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .onReceive(NotificationCenter.default.publisher(for: .openFavoritesSearch)) { _ in
                navigateToSearch = true
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 60) {
            
            Text("NO FAVORITES")
                .font(.title2)
                .fontWeight(.medium)
            
            Image("icons/Vector")
                .foregroundColor(.red)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.favorites, id: \.objectID) { favorite in
                    FavoriteEventCard(
                        favorite: favorite,
                        onDelete: {
                            eventToDelete = favorite
                            showingDeleteAlert = true
                        }
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
}

extension Notification.Name {
    static let openFavoritesSearch = Notification.Name("openFavoritesSearch")
}

#Preview {
    FavoritesView()
}
