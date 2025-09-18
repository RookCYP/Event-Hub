//
//  FavoritesService.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 15.09.25.
//


// /Modules/Favorites/Services/FavoritesService.swift
import CoreData

protocol FavoritesServiceProtocol {
    func addToFavorites(_ event: Event) async throws
    func removeFromFavorites(eventId: Int) async throws
    func isFavorite(eventId: Int) async -> Bool
    func fetchAllFavorites() async throws -> [FavoriteEvent]
    func searchFavorites(query: String) async throws -> [FavoriteEvent]
}

final class FavoritesService: FavoritesServiceProtocol {
    private let context = CoreDataStack.shared.viewContext
    
    func addToFavorites(_ event: Event) async throws {
        // Проверяем, не добавлено ли уже
        let request = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", event.id)
        request.fetchLimit = 1
        
        if try context.count(for: request) > 0 { return }
        
        // Создаём новую запись
        let favorite = FavoriteEvent(context: context)
        favorite.id = Int32(event.id)
        favorite.title = event.title
        favorite.shortTitle = event.shortTitle
        favorite.slug = event.slug
        favorite.imageURL = event.primaryImageURL?.absoluteString
        favorite.eventDescription = event.description
        favorite.location = event.location?.slug
        favorite.placeTitle = event.place?.title
        favorite.price = event.price
        favorite.isFree = event.isFree ?? false
        favorite.dateAdded = Date()
        
        // Даты события
        if let firstDate = event.dates.first {
            favorite.startDate = firstDate.startDateTime
            favorite.endDate = firstDate.endDateTime
        }
        
        // Сохраняем категории как JSON строку
        if let categories = event.categories,
           let data = try? JSONEncoder().encode(categories) {
            favorite.categories = String(data: data, encoding: .utf8)
        }
        
        try context.save() 
    }
    
    func removeFromFavorites(eventId: Int) async throws {
        let request = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", eventId)
        
        if let favorite = try context.fetch(request).first {
            context.delete(favorite)
            try context.save()
        }
    }
    
    func isFavorite(eventId: Int) async -> Bool {
        let request = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", eventId)
        request.fetchLimit = 1
        
        return (try? context.count(for: request)) ?? 0 > 0
    }
    
    func fetchAllFavorites() async throws -> [FavoriteEvent] {
        let request = FavoriteEvent.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        return try context.fetch(request)
    }
    
    func searchFavorites(query: String) async throws -> [FavoriteEvent] {
        let request = FavoriteEvent.fetchRequest()
        request.predicate = NSPredicate(
            format: "title CONTAINS[cd] %@ OR placeTitle CONTAINS[cd] %@",
            query, query
        )
        request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        return try context.fetch(request)
    }
}
