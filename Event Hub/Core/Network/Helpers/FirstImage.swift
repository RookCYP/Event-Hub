//
//  FirstImage.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 14.09.25.
//

import Foundation

struct FirstImage: Codable {
    let image: String?
    let thumbnails: [String: String]?
}
