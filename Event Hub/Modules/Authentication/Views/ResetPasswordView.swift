//
//  ResetPasswordView.swift
//  Event Hub
//
//  Created by Rook on 07.09.2025.
//

import SwiftUI

struct ResetPasswordView: View {
    @ObservedObject var authManager: AuthenticationManager
    let onNavigateBack: () -> Void
    
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
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
                
                // Input Fields
                VStack(spacing: 20) {
                    // New Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        if showPassword {
                            TextField("Your password", text: $newPassword)
                                .textFieldStyle(PlainTextFieldStyle())
                        } else {
                            SecureField("Your password", text: $newPassword)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Confirm Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        if showConfirmPassword {
                            TextField("Confirm password", text: $confirmPassword)
                                .textFieldStyle(PlainTextFieldStyle())
                        } else {
                            SecureField("Confirm password", text: $confirmPassword)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        
                        Button(action: { showConfirmPassword.toggle() }) {
                            Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                
                // Change Password Button
                Button(action: changePassword) {
                    HStack {
                        Text("CHANGE PASSWORD")
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
                        
                        Text("Password changed successfully!")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                        
                        Text("Your password has been updated. You can now sign in with your new password.")
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
    
    private func changePassword() {
        guard !newPassword.isEmpty && !confirmPassword.isEmpty else {
            authManager.errorMessage = "Please fill in all fields"
            return
        }
        
        guard newPassword == confirmPassword else {
            authManager.errorMessage = "Passwords do not match"
            return
        }
        
        guard newPassword.count >= 6 else {
            authManager.errorMessage = "Password must be at least 6 characters"
            return
        }
        
        authManager.resetPassword(newPassword: newPassword)
        
        // Показываем сообщение об успехе через небольшую задержку
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if authManager.errorMessage == nil {
                showSuccessMessage = true
            }
        }
    }
}

#Preview {
    ResetPasswordView(
        authManager: AuthenticationManager(),
        onNavigateBack: {}
    )
}
