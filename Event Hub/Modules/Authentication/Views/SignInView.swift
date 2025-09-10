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
    
    @State private var email = "@mail.com"
    @State private var password = ""
    @State private var rememberMe = true
    @State private var showPassword = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                VStack {
                    HStack {
                        Image("logoSignIn")
                            .padding(.horizontal, 70)
                        Spacer(minLength: 200.0)
                    }
                    HStack {
                        Text("EventHub")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.horizontal, 30)
                        Spacer()
                    }
                }
                
                HStack {
                    Text("Sign in")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            .padding(.top, 40)
            .padding(.bottom, 40)
            
            VStack(spacing: 20) {
                HStack {
                    Image("envelopeIcon")
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
                
                HStack {
                    Image("lockIcon")
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
            
            // Remember Me and Forgot Password
            HStack {
                Toggle("", isOn: $rememberMe)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color(red: 89/255, green: 105/255, blue: 246/255)))
                    .frame(height: 5)
                
                Text("Remember Me")
                    .font(.system(size: 14))
                    .padding(.leading, 20)
                Spacer()
                
                Button("Forgot Password?") {
                    onNavigateToForgotPassword()
                }
                .font(.system(size: 14))
            }
            .padding(.top, 20)
            
            CustomLongButton(title: "SIGN IN", action: signIn)
            
            Text("OR")
                .foregroundColor(.gray)
                .font(.system(size: 14))
                .padding(20)
            
            LoginGoogleButton(action: signInWithGoogle)
            
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
        .padding(.horizontal, 20)
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
