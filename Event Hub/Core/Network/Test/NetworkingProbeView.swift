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
    @State private var locations: [Location] = []
    @State private var selectedLocation = "spb" // Дефолтный город
    
    init(eventService: EventServiceProtocol = EventService()) {
        _vm = StateObject(wrappedValue: NetworkingProbeViewModel(eventService: eventService))
    }
    
    var body: some View {
        List {
            // Меню выбора города вверху
            Section {
                Menu {
                    ForEach(locations, id: \.slug) { location in
                        Button(location.name) {
                            selectedLocation = location.slug
                            Task {
                                await vm.loadInitial(location: location.slug)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Label("Город", systemImage: "location")
                        Spacer()
                        Text(locations.first { $0.slug == selectedLocation }?.name ?? "Санкт-Петербург")
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Ошибки
            if let err = vm.errorText {
                Section { Text(err).foregroundStyle(.red) }
            }
            
            // События
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
            
            // Загрузить еще
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
            // Загружаем города
            await loadLocations()
            // Загружаем события для выбранного города
            if vm.events.isEmpty {
                await vm.loadInitial(location: selectedLocation)
            }
        }
        .refreshable {
            await vm.loadInitial(location: selectedLocation)
        }
    }
    
    private func loadLocations() async {
        do {
            let service = LocationService()
            let loaded = try await service.fetchLocations()
            self.locations = loaded.filter {
                $0.coords?.lat != nil && $0.coords?.lon != nil
            }
        } catch {
            print("❌ Failed to load locations: \(error)")
        }
    }
}
