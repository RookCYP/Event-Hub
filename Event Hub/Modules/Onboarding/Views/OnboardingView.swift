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
    
    var body: some View {
        
        VStack {
            TabView(selection: $index) {
                VStack {
                    Image(.iPhoneX)
                    //                    .resizable()
                        .scaledToFit()
                    
                }
                .frame(height: 270)
                .tag(0)
                
                VStack {
                    Image(.iPhoneX2)
                    //                    .resizable()
                    
                    
                }
                .frame(height: 270)
                .tag(1)
                
                VStack {
                    Image(.iPhoneX3)
                    //                    .resizable()
                    
                    
                }
                .frame(height: 270)
                .tag(2)
            }
            .tabViewStyle(.page)             // превращает в страницы
            .indexViewStyle(.page(backgroundDisplayMode: .never))
        } // точки-индикаторы
        
        ZStack {
            RoundedRectangle(cornerRadius: 48)
                .fill(.blue)
                .ignoresSafeArea()
                .frame(height: 288)
            
            VStack(spacing: 20) {
                // Текст или кнопки тут при необходимости
                
                // Кастомные точки
                
                
                HStack {
                    // Skip
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
                                .frame(width: i == index ? 12 : 8,
                                       height: i == index ? 12 : 8)
                                .animation(.spring(), value: index)
                        }
                    }
                    Spacer()
                    
                    // Next / Get Started
                    Button(index == 2 ? "Get Started" : "Next") {
                        if index < 2 {
                            index += 1
                        } else {
                            hasSeenOnboarding = true
                        }
                    }
                    .foregroundStyle(.white)
                    .font(.headline)
                }
                .padding(40)
            }
        }
    }
}


// MARK: - скруглённые углы только сверху
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0
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

#Preview {
    OnboardingView()
}
