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
                } else if viewModel.filteredFavorites.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
            }
            //.navigationTitle("Избранное")
            .searchable(text: $viewModel.searchText, prompt: "Search...")
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
            
            Text(viewModel.searchText.isEmpty ? "NO FAVORITES" : "No results found")
                .font(.title2)
                .foregroundColor(.secondary)
            
            if !viewModel.searchText.isEmpty {
                Text("Try to change the search query")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var favoritesList: some View {
        List {
            ForEach(viewModel.filteredFavorites, id: \.objectID) { favorite in
                FavoriteRowView(favorite: favorite)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            eventToDelete = favorite
                            showingDeleteAlert = true
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
}

#Preview {
    FavoritesView()
}
