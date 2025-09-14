//
//  AuthenticationManager.swift
//  Event Hub
//
//  Created by Rook on 07.09.2025.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var user: User?
    
    private let rememberMeKey = "rememberMe"
    private let userEmailKey = "userEmail"
    
    init() {
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Status
    func checkAuthenticationStatus() {
        if UserDefaults.standard.bool(forKey: rememberMeKey) {
            // Если Remember Me включен, проверяем Firebase auth
            if let currentUser = Auth.auth().currentUser {
                self.user = currentUser
                self.isAuthenticated = true
            }
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String, rememberMe: Bool) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    self?.user = user
                    self?.isAuthenticated = true
                    self?.saveRememberMePreference(rememberMe, email: email)
                }
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, fullName: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    // Обновляем профиль пользователя с именем
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = fullName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print("Error updating profile: \(error.localizedDescription)")
                        }
                    }
                    
                    self?.user = user
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    // MARK: - Google Sign In
    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let presentingViewController = windowScene.windows.first(where: {$0.isKeyWindow })?.rootViewController else {
            isLoading = false
            errorMessage = "Unable to present Google Sign In"
            return
        }
        
        guard let _ = FirebaseApp.app()?.options.clientID else {
            isLoading = false
            errorMessage = "Firebase client ID not found"
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    guard let idToken = user.idToken?.tokenString else {
                        self?.errorMessage = "Failed to get ID token"
                        return
                    }
                    
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                    
                    Auth.auth().signIn(with: credential) { authResult, error in
                        if let error = error {
                            self?.errorMessage = error.localizedDescription
                        } else if let user = authResult?.user {
                            self?.user = user
                            self?.isAuthenticated = true
                            self?.saveRememberMePreference(true, email: user.email ?? "")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Forgot Password
    func sendPasswordReset(email: String) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    // Успешно отправлено письмо
                    self?.errorMessage = nil
                }
            }
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(newPassword: String) {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "No authenticated user found"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        user.updatePassword(to: newPassword) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    // Пароль успешно обновлен
                    self?.errorMessage = nil
                }
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            user = nil
            isAuthenticated = false
            UserDefaults.standard.set(false, forKey: rememberMeKey)
            UserDefaults.standard.removeObject(forKey: userEmailKey)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Helper Methods
    private func saveRememberMePreference(_ rememberMe: Bool, email: String) {
        UserDefaults.standard.set(rememberMe, forKey: rememberMeKey)
        if rememberMe {
            UserDefaults.standard.set(email, forKey: userEmailKey)
        } else {
            UserDefaults.standard.removeObject(forKey: userEmailKey)
        }
    }
}
