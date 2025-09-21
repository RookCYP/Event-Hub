//
//  EditProfileView.swift
//  Event Hub
//
//  Created by Aleksandr Zhazhoyan on 09.09.2025.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var tempName: String
    @State private var tempDescription: String
    @State private var tempImage: UIImage?
    @State private var showImagePicker = false
    @State private var isEditingName = false
    @State private var isEditingDescription = false
    @State private var isDescriptionExpanded = false
    @State private var hasChanges = false
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        _tempName = State(initialValue: viewModel.profile.name)
        _tempDescription = State(initialValue: viewModel.profile.description)
        if let data = viewModel.profile.avatarData,
           let uiImage = UIImage(data: data) {
            _tempImage = State(initialValue: uiImage)
        } else {
            _tempImage = State(initialValue: nil)
        }
    }
    
    var body: some View {
        //NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        ZStack {
                            if let image = tempImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 96, height: 96)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 96, height: 96)
                                    .foregroundStyle(.gray.opacity(0.6))
                            }
                            
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .frame(width: 96, height: 96)
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(Color("MyBlue"))
                                        .clipShape(Circle())
                                        .offset(x: 5, y: 5)
                                }
                            }
                            .frame(width: 96, height: 96)
                        }
                        .onTapGesture {
                            showImagePicker = true
                            hasChanges = true
                        }
                        
                        HStack {
                            if isEditingName {
                                TextField("Name", text: $tempName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.title2)
                                    .onChange(of: tempName) { _ in
                                        hasChanges = true
                                    }
                            } else {
                                Text(tempName)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    isEditingName.toggle()
                                    hasChanges = true
                                }
                            }) {
                                Image(systemName: isEditingName ? "checkmark.circle.fill" : "square.and.pencil")
                                    .foregroundColor(Color("MyBlue"))
                                    .font(.title3)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("About Me")
                                    .font(.headline)
                                
                                Button(action: {
                                    withAnimation {
                                        isEditingDescription.toggle()
                                        hasChanges = true
                                    }
                                }) {
                                    Image(systemName: isEditingDescription ? "checkmark.circle.fill" : "square.and.pencil")
                                        .foregroundColor(Color("MyBlue"))
                                        .font(.headline)
                                }
                                
                                Spacer()
                            }
                            
                            if isEditingDescription {
                                TextEditor(text: $tempDescription)
                                    .frame(minHeight: 100, maxHeight: 200)
                                    .padding(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                    .onChange(of: tempDescription) { _ in
                                        hasChanges = true
                                    }
                            } else {
                                if isDescriptionExpanded {
                                    ScrollView(.vertical, showsIndicators: true) {
                                        Text(tempDescription)
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .frame(height: 250)
                                } else {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(String(tempDescription.prefix(100)))
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                        
                                        Text("Read More")
                                            .font(.body)
                                            .foregroundColor(Color("MyBlue"))
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            isDescriptionExpanded.toggle()
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        
                    }
                    .padding(.vertical, 20)
                }
               
                Button(action: {
                    viewModel.signOut()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Sign Out")
                    }
                    .foregroundStyle(Color.black)
                    .padding()
                }
                .padding(.bottom, 80)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        
                        Image(.Icons.arrowLeft)
                            .foregroundColor(Color.myBlue)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!hasChanges)
                    .foregroundColor(hasChanges ? Color("MyBlue") : .gray)
                }
            }
        //}
    }
    
    private func saveChanges() {
        viewModel.profile.name = tempName
        viewModel.profile.description = tempDescription
        if let img = tempImage {
            viewModel.profile.avatarData = img.jpegData(compressionQuality: 0.8)
        }
        viewModel.isEditingProfile = false
    }
}
