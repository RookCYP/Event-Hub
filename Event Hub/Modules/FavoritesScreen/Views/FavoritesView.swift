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
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading favorites...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.favorites.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
            }
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
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "bookmark")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("NO FAVORITES")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text("Add events to your favorites\nto see them here")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
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

#Preview {
    FavoritesView()
}
