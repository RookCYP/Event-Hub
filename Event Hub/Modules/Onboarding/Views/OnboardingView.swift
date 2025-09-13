//
//  OnboardingView.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/8/25.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var index = 0
    
    let titles = [
        "Explore Upcoming and\nNearby Events",
        "Web Have Modern Events\nCalendar Feature",
        "To Look Up More Events or\nActivities Nearby By Map"
    ]
    
    let subtitles = [
        "In publishing and graphic design, Lorem is a placeholder text commonly",
        "2In publishing and graphic design, Lorem is a placeholder text commonly",
        "3In publishing and graphic design, Lorem is a placeholder text commonly"
    ]
    
   
    
    var body: some View {
        ZStack {
            TabView(selection: $index) {
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
                        Text(titles[index])
                            .font(.title2.bold())
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .id(index)
                            .transition(.opacity)
                        
                        // Subtitle
                        Text(subtitles[index])
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.85))
                            .padding(.horizontal, 24)
                            .id(index + 100)
                            .transition(.opacity)
                        
                        // Buttons and dots
                        HStack() {
                            Button("Skip") {
                                hasSeenOnboarding = true
                            }
                            .foregroundStyle(.white.opacity(0.7))
                            .font(.headline)
                            
                            Spacer()
                            
                            HStack(spacing: 10) {
                                ForEach(0..<3) { i in
                                    Circle()
                                        .fill(i == index ? .white : .white.opacity(0.4))
                                        .frame(width: 8, height: 8)
                                }
                            }
                            
                            Spacer()
                            
                            Button(index == 2 ? "Start" : "Next") {
                                if index < 2 {
                                    withAnimation(.easeInOut) {
                                        index += 1
                                    }
                                    
                                } else {
                                    hasSeenOnboarding = true
                                }
                            }
//                            .frame(width: 70, height: 8)
                            .foregroundStyle(.white)
                            .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 40)
                        .padding(.top, 43)
                    }
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


