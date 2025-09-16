//
//  ExploreView.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var router: Router
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Location")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                    Text("New York, USA")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white)
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 44, height: 44)
                    Image(systemName: "bell.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 20, weight: .semibold))
                }
            }

            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search...", text: .constant(""))
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "slider.horizontal.3")
                        Text("Filters")
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
            }

            HStack(spacing: 16) {
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "sportscourt")
                        Text("Sports")
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "music.note")
                        Text("Music")
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                Button(action: {}) {
                    HStack(spacing: 6) {
                        Image(systemName: "fork.knife")
                        Text("Food")
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 24)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(
            Color.blue
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .ignoresSafeArea(edges: .top),
            alignment: .top
        )
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming Events")
                .font(.title2).bold()
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<10, id: \.self) { _ in
                        EventBigCardView(
                            image: Image("International Band Mu"),
                            date: "10 June",
                            title: "A Virtual Evening of Smooth Jazz",
                            location: "Lot 13 • Oakland, CA",
                            isFavorite: true
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 0)
        
        VStack(alignment: .leading, spacing: 16) {
            Text("Nearby You")
                .font(.title2).bold()
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<10, id: \.self) { _ in
                        EventBigCardView(
                            image: Image("International Band Mu"),
                            date: "10 June",
                            title: "A Virtual Evening of Smooth Jazz",
                            location: "Lot 13 • Oakland, CA",
                            isFavorite: true
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top, 0)
    }
    
}

#Preview {
    ExploreView()
}
