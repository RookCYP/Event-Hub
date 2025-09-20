//
//  FavoriteEvent+Extensions.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 15.09.25.
//

// /Modules/Favorites/Models/FavoriteEvent+Extensions.swift
// Расширения для Core Data модели
import SwiftUI

extension FavoriteEvent {
    var formattedDateString: String {
        guard let startDate = startDate else {
            return "Дата не указана"
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "E, MMM d • h:mm a"
        return formatter.string(from: startDate)
    }
    
    var formattedLocation: String {
        placeTitle ?? "Место не указано"
    }
    
    var displayTitle: String {
        title ?? "Без названия"
    }
}
