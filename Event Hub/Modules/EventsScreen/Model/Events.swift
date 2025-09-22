//
//  Events.swift
//  Event-Hub
//
//  Created by Aleksandr Zhazhoyan on 17.09.2025.
//

import Foundation

struct Events: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let location: String
    let imageName: String
    var isFavorite: Bool
}
