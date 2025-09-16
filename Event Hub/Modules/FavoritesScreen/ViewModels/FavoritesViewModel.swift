//
//  FavoritesViewModel.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 15.09.25.
//

// /Modules/Favorites/ViewModels/FavoritesViewModel.swift
import SwiftUI
import CoreData

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteEvent] = []
    @Published var isLoading = false
    @Published var searchText = ""
    
    private let favoritesService = FavoritesService()
    
    var filteredFavorites: [FavoriteEvent] {
        if searchText.isEmpty {
            return favorites
        }
        return favorites.filter {
            $0.title?.localizedCaseInsensitiveContains(searchText) ?? false ||
            $0.placeTitle?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
    
    func loadFavorites() async {
        isLoading = true
        do {
            favorites = try await favoritesService.fetchAllFavorites()
        } catch {
            print("Error loading favorites: \(error)")
        }
        isLoading = false
    }
    
    func removeFromFavorites(_ favorite: FavoriteEvent) async {
        do {
            try await favoritesService.removeFromFavorites(eventId: Int(favorite.id))
            await loadFavorites()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
}
