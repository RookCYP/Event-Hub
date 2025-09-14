//
//  ProfileView.swift
//  Event Hub
//
//  Created by Aleksandr Zhazhoyan on 09.09.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel(
        profile: Profile(
            name: "Taylor Swift",
            description: """
About me , sfkasfnjasfsajfksafkasf, asd ,asldf s,d aslf,das,d as,das ,das,d as,d ,sa d,as dsdasdasdsadsadsad sadasd sd asd sad asd sad sad s das das d asd ad asd sad asd asd as das das d asd sad sd asd as das das a sd sd s da d ad asd as ds d sad asd asd sad a dsa d asd asd asd as d sd as da sd asd a das d da sd as das d asd asd as das d sa da dass d asd sa d as da
""",
            avatarData: nil
        ),
        authManager: AuthenticationManager()
    )
    
    @State private var isDescriptionExpanded = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        ZStack {
                            if let avatarData = viewModel.profile.avatarData,
                               let image = UIImage(data: avatarData) {
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
                        }
                        
                        
                        Text(viewModel.profile.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        NavigationLink(destination: EditProfileView(viewModel: viewModel)
                            .navigationBarBackButtonHidden(true)
                        ) {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                Text("Edit Profile")
                            }
                            .font(.subheadline)
                            .frame(width: 110, height: 35)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("MyBlue"), lineWidth: 1)
                            )
                        }
                        .foregroundStyle(Color("MyBlue"))
                        
                        Spacer()
                        
                       
                        VStack(alignment: .leading, spacing: 20) {
                            Text("About Me")
                                .font(.headline)
                            
                            if isDescriptionExpanded {
                                if viewModel.profile.description.count > 200 {
                                    
                                    ScrollView(.vertical, showsIndicators: true) {
                                        Text(viewModel.profile.description)
                                            .font(.body)
                                            .foregroundStyle(.black)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.trailing, 4)
                                    }
                                    .frame(height: 250)
                                } else {
                                    
                                    Text(viewModel.profile.description)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            } else {
                                Text(String(viewModel.profile.description.prefix(100)))
                                    .font(.body)
                                    .foregroundColor(.black)
                                + Text(" ")
                                + Text("Read More")
                                    .font(.body)
                                    .foregroundColor(Color("MyBlue"))
                            }
                        }
                        .onTapGesture {
                            if !isDescriptionExpanded {
                                withAnimation {
                                    isDescriptionExpanded.toggle()
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
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
            //.navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
            }
            
        }
    }
}

#Preview {
    ProfileView()
}
