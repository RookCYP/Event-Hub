//
//  EventsView.swift
//  Event-Hub
//
//  Created by Aleksandr Zhazhoyan on 17.09.2025.
//

import SwiftUI

struct EventsView: View {
    @StateObject private var viewModel = EventsViewModel()
    
    var body: some View {
        VStack {
            Text("Events")
                .font(.title)
                .bold()
                .padding(.top, 10)
            
            HStack(spacing: 5) {
                tabButton(title: "UPCOMING", tab: .upcoming)
                tabButton(title: "PAST EVENTS", tab: .past)
            }
            .padding(.vertical, 15)
            
            Spacer()
            
            if viewModel.currentEvents.isEmpty {
                VStack(spacing: 20) {
                    Image("calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 202, height: 202)
                    
                    Text("No Upcoming Event")
                        .font(.title)
                        .bold()
                    
                    Text("Lorem ipsum dolor sit amet, consectetur")
                        .font(.headline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .frame(width: 312, height: 50)
                }
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.currentEvents) { event in
                            EventCardView(
                                image: Image(event.imageName),
                                date: event.date.formatted(date: .abbreviated, time: .shortened),
                                title: event.title,
                                location: event.location,
                                isFavorite: event.isFavorite
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            Spacer()
            
            CustomLongButton(title: "EXPLORE EVENTS", action: viewModel.addTestEvent)
                .padding(.bottom, 100)
        }
    }
    
    private func tabButton(title: String, tab: EventsTab) -> some View {
        Button {
            viewModel.selectedTab = tab
        } label: {
            Text(title)
                .font(.subheadline)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(viewModel.selectedTab == tab ? Color.blue.opacity(0.1) : Color.clear)
                .cornerRadius(20)
                .foregroundStyle(viewModel.selectedTab == tab ? .purple : .gray)
        }
    }
}



#Preview {
    EventsView()
}
