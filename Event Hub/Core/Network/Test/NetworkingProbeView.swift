//
//  NetworkingProbeView.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//

// заглушка для теста сети
import SwiftUI
import Kingfisher

struct NetworkingProbeView: View {
    @StateObject private var vm: NetworkingProbeViewModel

    init(eventService: EventServiceProtocol = EventService()) {
        _vm = StateObject(wrappedValue: NetworkingProbeViewModel(eventService: eventService))
    }

    var body: some View {
        List {
            if let err = vm.errorText {
                Section { Text(err).foregroundStyle(.red) }
            }

            ForEach(vm.events, id: \.id) { event in
                HStack(spacing: 12) {
                    KFImage(event.primaryImageURL)
                        .placeholder { ProgressView() }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    VStack(alignment: .leading, spacing: 6) {
                        Text(event.title).font(.headline).lineLimit(2)
                        if let place = event.place?.title, !place.isEmpty {
                            Text(place).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                }
            }

            if vm.nextPageURL != nil {
                Button {
                    Task { await vm.loadNextPage() }
                } label: {
                    vm.isLoading ? AnyView(ProgressView().frame(maxWidth: .infinity)) :
                                   AnyView(Text("Load more").frame(maxWidth: .infinity))
                }
            }
        }
        .overlay {
            if vm.events.isEmpty && vm.isLoading {
                ProgressView("Loading…")
            }
        }
        .navigationTitle("Networking Probe")
        .task {
            if vm.events.isEmpty { await vm.loadInitial(location: "spb") }
        }
        .refreshable {
            await vm.loadInitial(location: "spb")
        }
    }
}
