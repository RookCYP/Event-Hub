//
//  LoginGoogleButton.swift
//  Event Hub
//
//  Created by Валентин on 10.09.2025.
//

import SwiftUI

struct LoginGoogleButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: action) {
                HStack {
                    Image("googleIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Text("Login with Google")
                        .fontWeight(.medium)
                    
                    Spacer()
                }
                .foregroundColor(.black)
                .padding()
                .frame(width: geometry.size.width * 0.8)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 6, x: 2, y: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 20)
        }
        .frame(height: 50)
        .padding(.top, 20)

    }
}

#Preview {
    LoginGoogleButton(action: {})
}
