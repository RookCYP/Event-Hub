//
//  CategoryService.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//

// /Core/Network/Services/CategoryService.swift

protocol CategoryServiceProtocol {
    func fetchCategories() async throws -> [Category]
}

final class CategoryService: CategoryServiceProtocol {
    private let api = APIClient.shared
    
    func fetchCategories() async throws -> [Category] {
        // Напрямую декодируем массив, не wrapper
        let categories: [Category] = try await api.request(
            endpoint: .categories,
            parameters: [
                "page_size": 100
            ]
        )
        return categories
    }
}
