//
//  FavoritesSearchView.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 20.09.25.
//

// FavoritesSearchView.swift
import SwiftUI

struct FavoritesSearchView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @State private var searchText = ""
    @State private var showingDeleteAlert = false
    @State private var eventToDelete: FavoriteEvent?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search in favorites...", text: $searchText)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Results
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading...")
                    Spacer()
                } else if filteredFavorites.isEmpty && !searchText.isEmpty {
                    // Показываем "не найдено" только если есть текст поиска
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("No results found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Try different keywords")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                } else if viewModel.favorites.isEmpty {
                    // Если вообще нет избранных
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("No favorites yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Add events to favorites first")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                } else {
                    // Показываем список (все или отфильтрованные)
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredFavorites, id: \.objectID) { favorite in
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
            .navigationTitle("Search Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await viewModel.loadFavorites()
        }
        .alert("Remove from favorites?", isPresented: $showingDeleteAlert) {
            Button("Remove", role: .destructive) {
                if let event = eventToDelete {
                    Task {
                        await viewModel.removeFromFavorites(event)
                        // Не нужно перезагружать все, просто обновится через @Published
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private var filteredFavorites: [FavoriteEvent] {
        if searchText.isEmpty {
            return viewModel.favorites  // Возвращаем все при пустой строке
        }
        return viewModel.favorites.filter {
            $0.title?.localizedCaseInsensitiveContains(searchText) ?? false ||
            $0.placeTitle?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
}
