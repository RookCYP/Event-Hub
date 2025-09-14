//
//  OnboardingView.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/8/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject private var vm = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            TabView(selection: $vm.index) {
                ScreenImage(image: .init(.iPhoneX))
                    .tag(0)
                    .padding(.horizontal, 52)
                
                ScreenImage(image: .init(.iPhoneX2))
                    .tag(1)
                    .padding(.horizontal, 52)
                
                ScreenImage(image: .init(.iPhoneX3))
                    .tag(2)
                    .padding(.horizontal, 52)
            }
            .tabViewStyle(.page)
            .padding(.bottom, 195)
            
            VStack {
                Spacer()
                ZStack {
                    
                    RoundedCorner(radius: 48, corners: [.topLeft, .topRight])
                        .fill(.blue)
                        .frame(height: 288)
                    
                    VStack(spacing: 16) {
                        // Title
                        Text(vm.titles[vm.index])
                            .font(.title2.bold())
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                        
                        // Subtitle
                        Text(vm.subtitles[vm.index])
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            
                        
                        // Buttons and dots
                        HStack() {
                            Button("Skip") {
                                vm.skip()
                            }
                            .foregroundStyle(.white.opacity(0.7))
                            .font(.headline)
                            
                            Spacer()
                            
                            HStack(spacing: 10) {
                                ForEach(0..<3) { index in
                                    Circle()
                                        .fill(index == vm.index ? .white : .white.opacity(0.4))
                                        .frame(width: 8, height: 8)
                                }
                            }
                            
                            Spacer()
                            
                            Button(vm.isLastPage ? "Start" : "Next") {
                                vm.next()
                            }
                            .foregroundStyle(.white)
                            .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 43)
                    }
                    .padding(.horizontal, 40)
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    OnboardingView()
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


