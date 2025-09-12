//
//  EventsListView.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 12.09.25.
//

import SwiftUI

struct EventsListView: View {
    let events: [Event]
    let nextPageURL: URL?
    let isLoading: Bool
    let onLoadMore: () async -> Void
    
    var body: some View {
        ForEach(events, id: \.id) { event in
            EventRowView(event: event)
        }
        
        if nextPageURL != nil {
            Button {
                Task { await onLoadMore() }
            } label: {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Load more")
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
