//
//  CustomNavBar.swift
//  BestRecipes
//
//  Created by Валентин on 22.08.2025.
//

import SwiftUI

struct CustomNavBar: View {
    let title: String
    var showSearchButton: Bool = false
    var onSearchTap: (() -> Void)?
    
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
            
            Spacer()
            
            if showSearchButton {
                Button(action: {
                    onSearchTap?()
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}

#Preview {
    CustomNavBar(title: "Get amazing recipes for cooking")
}
