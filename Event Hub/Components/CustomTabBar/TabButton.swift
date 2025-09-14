//
//  TabButton.swift
//  BestRecipes
//
//  Created by Drolllted on 10.08.2025.
//

import SwiftUI

struct TabButton: View {
        
    let tab: TabEnum
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(tab.icon)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                
                Text(tab.title)
                    .font(.system(size: 12))
            }
            .foregroundColor(isSelected ? Color("appPrimary") : .gray)
        }
    }
}

#Preview {
    TabButton(tab: .explore, isSelected: false, action: {})
    TabButton(tab: .events, isSelected: true, action: {})
    TabButton(tab: .favorites, isSelected: false, action: {})
    TabButton(tab: .map, isSelected: false, action: {})
    TabButton(tab: .profile, isSelected: false, action: {})
}
