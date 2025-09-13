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
    
    private let opacityGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: .white, location: 0.0),
            .init(color: .white, location: 0.65),
            .init(color: .clear, location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    var body: some View {
        ZStack {
            TabView(selection: $index) {
                Image(.iPhoneX)
                    .resizable()
                    .scaledToFit()
                
                    .tag(0)
                    .mask(
                        opacityGradient
                    )
                    .padding(.horizontal, 52)
                
                
                Image(.iPhoneX2)
                    .scaledToFit()
                
                    .tag(1)
                    .mask(
                        opacityGradient
                    )
                    .padding(.horizontal, 52)
                
                Image(.iPhoneX3)
                    .scaledToFit()
                
                    .tag(2)
                    .mask(
                        opacityGradient
                    )
                    .padding(.horizontal, 52)
            }
            .tabViewStyle(.page)
            .padding(.bottom, 195)
            
            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 48)
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
                        
                        // Кнопки и точки
                        HStack {
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
                            .foregroundStyle(.white)
                            .font(.headline)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 43)
                    }
//                    .padding(.top, 24)
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    OnboardingView()
}
