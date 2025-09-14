//
//  ProfileViewModel.swift
//  Event Hub
//
//  Created by Aleksandr Zhazhoyan on 09.09.2025.
//

import Foundation
import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var profile: Profile
    @EnvironmentObject var authManager: AuthenticationManager
    
    @Published var isShowingImagePicker = false
    @Published var isEditingProfile = false
    
    @Published var selectedImage: UIImage? {
        didSet {
            if let image = selectedImage {
                profile.avatarData = image.jpegData(compressionQuality: 0.8)
            }
        }
    }
    
    init(profile: Profile, authManager: AuthenticationManager) {
        self.profile = profile
    }
    
    func editProfile() {
        isEditingProfile = true
    }
    
    func signOut() {
        authManager.signOut()
    }
}
