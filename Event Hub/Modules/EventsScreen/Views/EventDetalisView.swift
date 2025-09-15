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
                VStack(alignment: .leading) {
                    Text("International Band Music Concert")
                        .font(.largeTitle)
                       
                    // first
                    HStack {
                        // TODOO change icon
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading) {
                            Text("14 December 2021")
                            
                            Text("Tuesday, 4:00 pm - 9:00 pm")
                        }
                    }
                    // second
                    HStack {
                        // TODOO change icon
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading) {
                            Text("Gala Convention Centre")
                            
                            Text("36 Guild Street London, UK")
                        }
                    }
                    // third
                    HStack {
                        // TODOO change icon
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading) {
                            Text("Ashfak Sayem")
                            
                            Text("Organizer")
                        }
                    }
                    
                    Text("About Event")
                        .font(.title)
                    
                    Text("Discover events you’ll love and make every day unforgettable. Plan your perfect schedule with just a few taps, explore exciting activities happening near you, and connect with the moments that matter most. Stay inspired, stay informed, and never miss what’s happening around you! Discover events you’ll love and make every day unforgettable. Plan your perfect schedule with just a few taps, explore exciting activities happening near you, and connect with the moments that matter most. Stay inspired, stay informed, and never miss what’s happening around you! Discover events you’ll love and make every day unforgettable. Plan your perfect schedule with just a few taps, explore exciting activities happening near you, and connect with the moments that matter most. Stay inspired, stay informed, and never miss what’s happening around you!")
                    
                    
                }
                .padding(.top, 50)
            }
            .padding(.horizontal, 21)
        }
//        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    EventDetalisView()
}
