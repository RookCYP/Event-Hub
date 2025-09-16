//
//  EventDetalisView.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/14/25.
//

import SwiftUI
import UIKit

struct EventDetalisView: View {
    @State private var showShare = false

      // Что шарим (URL + текст)
      private var shareItems: [Any] {
          [
              URL(string: "https://youreventhub.app/event/123")!,
              "International Band Music Concert — don’t miss it! "
          ]
      }

      var body: some View {
          VStack {
              ZStack(alignment: .bottomTrailing) {
                  Image(.concert)
                      .resizable()
                      .scaledToFill()
                      .frame(height: 244)
                      .clipped()

                  // Кнопка share поверх картинки
                  Button {
                      showShare = true
                  } label: {
                      Image(.shareIcon)
                          .resizable()
                          .frame(width: 36, height: 36)
                          
                          
                  }
                  .padding(20)
              }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("International Band Music Concert")
                        .font(.largeTitle)
                       
                    // first
                    HStack {
                        // TODOO change icon
                        Image(.dateIcon)
                            .resizable()
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
                        Image(.locationblueIcon)
                            .resizable()
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
                        Image(.imageIcon)
                            .resizable()
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
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $showShare) {
                       ActivityView(
                           items: shareItems,
                           subject: "Share with friends",
                           excluded: [.assignToContact, .print] // опционально: убрать лишнее
                       )
                   }
            .padding(.horizontal, 21)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    EventDetalisView()
}

struct ActivityView: UIViewControllerRepresentable {
    var items: [Any]
    var subject: String? = nil
    var excluded: [UIActivity.ActivityType] = []

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let subject { vc.setValue(subject, forKey: "subject") }     // тема для Mail
        vc.excludedActivityTypes = excluded
        return vc
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
