//
//  SignUpView.swift
//  Event Hub
//
//  Created by Rook on 07.09.2025.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var authManager: AuthenticationManager
    let onNavigateToSignIn: () -> Void
    
    @State private var fullName = ""
    @State private var email = "@mail.com"
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 20) {
                Text("Sign up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .padding(.top, 40)
            .padding(.bottom, 40)
            
            // Input Fields
            VStack(spacing: 20) {
                // Full Name Field
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                        .frame(width: 20)
                    
                    TextField("Full name", text: $fullName)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
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
                
                // Password Field
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                        .frame(width: 20)
                    
                    if showPassword {
                        TextField("Your password", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                    } else {
                        SecureField("Your password", text: $password)
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
            
            CustomLongButton(title: "SIGN UP", action: signUp)
            
            Text("OR")
                .foregroundColor(.gray)
                .font(.system(size: 14))
                .padding(20)
            
            LoginGoogleButton(action: signInWithGoogle)
            
            Spacer()
            
            // Sign In Link
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                
                Button("Signin") {
                    onNavigateToSignIn()
                }
                .foregroundColor(.blue)
                .font(.body.weight(.medium))
            }
            .padding(.bottom, 40)
            
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
    
    private func signUp() {
        guard !fullName.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty else {
            authManager.errorMessage = "Please fill in all fields"
            return
        }
        
        guard password == confirmPassword else {
            authManager.errorMessage = "Passwords do not match"
            return
        }
        
        guard password.count >= 6 else {
            authManager.errorMessage = "Password must be at least 6 characters"
            return
        }
        
        authManager.signUp(email: email, password: password, fullName: fullName)
    }
    
    private func signInWithGoogle() {
        authManager.signInWithGoogle()
    }
}

#Preview {
    SignUpView(
        authManager: AuthenticationManager(),
        onNavigateToSignIn: {}
    )
}
