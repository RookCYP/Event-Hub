//
//  ForgotPasswordView.swift
//  Event Hub
//
//  Created by Rook on 07.09.2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var authManager: AuthenticationManager
    let onNavigateBack: () -> Void
    
    @State private var email = "abc@email.com"
    @State private var showSuccessMessage = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Header
            HStack {
                Button(action: onNavigateBack) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Content
            VStack(spacing: 30) {
                // Title
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                // Instructions
                Text("Please enter your email address to request a password reset")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                // Email Field
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                        .frame(width: 20)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                // Send Button
                Button(action: sendPasswordReset) {
                    HStack {
                        Text("SEND")
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                
                // Success Message
                if showSuccessMessage {
                    VStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                        
                        Text("Password reset email sent!")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                        
                        Text("Please check your email and follow the instructions to reset your password.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            
            // Error Message
            if let errorMessage = authManager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        .disabled(authManager.isLoading)
        .overlay(
            Group {
                if authManager.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        )
    }
    
    private func sendPasswordReset() {
        guard !email.isEmpty else {
            authManager.errorMessage = "Please enter your email address"
            return
        }
        
        guard isValidEmail(email) else {
            authManager.errorMessage = "Please enter a valid email address"
            return
        }
        
        authManager.sendPasswordReset(email: email)
        
        // Показываем сообщение об успехе через небольшую задержку
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if authManager.errorMessage == nil {
                showSuccessMessage = true
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    ForgotPasswordView(
        authManager: AuthenticationManager(),
        onNavigateBack: {}
    )
}
