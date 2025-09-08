//
//  AuthenticationView.swift
//  Event Hub
//
//  Created by Rook on 07.09.2025.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var currentScreen: AuthScreen = .signIn
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    switch currentScreen {
                    case .signIn:
                        SignInView(
                            authManager: authManager,
                            onNavigateToSignUp: { currentScreen = .signUp },
                            onNavigateToForgotPassword: { currentScreen = .forgotPassword }
                        )
                    case .signUp:
                        SignUpView(
                            authManager: authManager,
                            onNavigateToSignIn: { currentScreen = .signIn }
                        )
                    case .forgotPassword:
                        ForgotPasswordView(
                            authManager: authManager,
                            onNavigateBack: { currentScreen = .signIn }
                        )
                    case .resetPassword:
                        ResetPasswordView(
                            authManager: authManager,
                            onNavigateBack: { currentScreen = .signIn }
                        )
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

enum AuthScreen {
    case signIn
    case signUp
    case forgotPassword
    case resetPassword
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationManager())
}
