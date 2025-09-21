//
//  SearchView.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

import SwiftUI

struct SearchView: View {
    let category: String?
    
    init(category: String? = nil) {
        self.category = category
    }
    
    var body: some View {
        Text("This is Search Screen")
    }
}

#Preview {
    SearchView()
}
