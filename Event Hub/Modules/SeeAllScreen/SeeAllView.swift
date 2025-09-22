//
//  SeeAllView.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

// SeeAllView.swift
import SwiftUI

struct SeeAllView: View {
    let category: String
    @StateObject private var viewModel: SeeAllViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(category: String) {
        self.category = category
        self._viewModel = StateObject(wrappedValue: SeeAllViewModel(category: category))
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading && viewModel.events.isEmpty {
                ProgressView("Loading events...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.events.isEmpty {
                emptyStateView
            } else {
                eventsList
            }
        }
        .navigationTitle(categoryTitle)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(.Icons.arrowLeft)
                        .foregroundColor(.primary)
                }
            }
        }
        .task {
            await viewModel.loadInitial()
        }
        .refreshable {
            await viewModel.loadInitial()
        }
    }
    
    private var eventsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.events, id: \.id) { event in
                    EventListCard(event: event)
                        .padding(.horizontal)
                }
                
                // Load more button
                if viewModel.nextPageURL != nil {
                    Button(action: {
                        Task {
                            await viewModel.loadNextPage()
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Load more")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No \(categoryTitle)")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Check back later for new events")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var categoryTitle: String {
        switch category {
        case "upcoming":
            return "Upcoming Events"
        case "nearby":
            return "Nearby Events"
        case "sports":
            return "Sports"
        case "music":
            return "Music"
        case "food":
            return "Food & Drinks"
        case "art":
            return "Art & Culture"
        case "education":
            return "Education"
        default:
            return "All Events"
        }
    }
}
