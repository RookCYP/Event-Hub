//
//  SignInView.swift
//  Event Hub
//
//  Created by Rook on 07.09.2025.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var authManager: AuthenticationManager
    let onNavigateToSignUp: () -> Void
    let onNavigateToForgotPassword: () -> Void
    
    @State private var email = "abc@email.com"
    @State private var password = ""
    @State private var rememberMe = true
    @State private var showPassword = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 20) {
                Text("Sign in")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                // App Logo
                HStack(spacing: 8) {
                    Image(systemName: "e.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                    
                    Text("EventHub")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
            }
            .padding(.top, 40)
            .padding(.bottom, 40)
            
            // Input Fields
            VStack(spacing: 20) {
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
            }
            .padding(.horizontal, 20)
            
            // Remember Me and Forgot Password
            HStack {
                Toggle("Remember Me", isOn: $rememberMe)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                
                Spacer()
                
                Button("Forgot Password?") {
                    onNavigateToForgotPassword()
                }
                .foregroundColor(.blue)
                .font(.system(size: 14))
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Sign In Button
            Button(action: signIn) {
                HStack {
                    Text("SIGN IN")
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
            .padding(.top, 30)
            
            // Divider
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
                
                Text("OR")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .padding(.horizontal, 16)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            
            // Google Sign In Button
            Button(action: signInWithGoogle) {
                HStack {
                    Image(systemName: "globe")
                        .font(.system(size: 16))
                    
                    Text("Login with Google")
                        .fontWeight(.medium)
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
            
            // Sign Up Link
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button("Sign up") {
                    onNavigateToSignUp()
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
    
    private func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            authManager.errorMessage = "Please fill in all fields"
            return
        }
        
        authManager.signIn(email: email, password: password, rememberMe: rememberMe)
    }
    
    private func signInWithGoogle() {
        authManager.signInWithGoogle()
    }
}

#Preview {
    SignInView(
        authManager: AuthenticationManager(),
        onNavigateToSignUp: {},
        onNavigateToForgotPassword: {}
    )
}
