//
//  EventDetalisView.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/14/25.
//

import SwiftUI

struct EventDetalisView: View {
    var body: some View {
        VStack {
            ZStack {
                Image(.concert)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 244)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("International Band Music Concert")
                        .font(.largeTitle)
                       
                    // first
                    HStack {
                        // TODOO change icon
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.appIndigo)
                            .opacity(0.12)
                            .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading) {
                            Text("14 December 2021")
                                .font(.headline)
                            
                            Text("Tuesday, 4:00 pm - 9:00 pm")
                                .font(.subheadline)
                        }
                    }
                    // second
                    HStack {
                        // TODOO change icon
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.appIndigo)
                            .opacity(0.12)
                            .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading) {
                            Text("Gala Convention Centre")
                                .font(.headline)
                            
                            Text("36 Guild Street London, UK")
                                .font(.subheadline)
                        }
                    }
                    // third
                    HStack {
                        // TODOO change icon
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading) {
                            Text("Ashfak Sayem")
                                .font(.headline)
                            
                            Text("Organizer")
                                .font(.subheadline)
                        }
                    }
                    
                    Text("About Event")
                        .font(.title)
                    
                    Text("Discover events you’ll love and make every day unforgettable. Plan your perfect schedule with just a few taps, explore exciting activities happening near you, and connect with the moments that matter most. Stay inspired, stay informed, and never miss what’s happening around you! Discover events you’ll love and make every day unforgettable. Plan your perfect schedule with just a few taps, explore exciting activities happening near you, and connect with the moments that matter most. Stay inspired, stay informed, and never miss what’s happening around you! Discover events you’ll love and make every day unforgettable. Plan your perfect schedule with just a few taps, explore exciting activities happening near you, and connect with the moments that matter most. Stay inspired, stay informed, and never miss what’s happening around you!")
                    
                    
                }
                .padding(.top, 30)
            }
            .padding(.horizontal, 21)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    EventDetalisView()
}
