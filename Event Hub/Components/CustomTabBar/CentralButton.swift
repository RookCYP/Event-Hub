//
//  CentralButton.swift
//  BestRecipes
//
//  Created by Drolllted on 10.08.2025.
//

import SwiftUI

struct CentralButton: View {
    @Binding var selected: TabEnum
    var index: TabEnum
    
    var body: some View {
        Button {
        selected = index
        } label: {
            ZStack {
                Circle()
                    .fill(Color("indigoColor"))
                    .frame(width: 44, height: 44)
                  
                Image("favoritesIconForTabBar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 17, height: 17)
                
            }
        }

    }
}
