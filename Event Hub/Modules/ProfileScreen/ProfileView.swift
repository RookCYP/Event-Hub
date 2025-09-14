//
//  ProfileView.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            Text("This is Profile Screen")
            Button {
                authManager.signOut()
            } label: {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    ProfileView()
}
