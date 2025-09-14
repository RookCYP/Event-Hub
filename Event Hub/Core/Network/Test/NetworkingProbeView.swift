//
//  NetworkingProbeView.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//

// заглушка для теста сети
import SwiftUI

struct NetworkingProbeView: View {
    @StateObject private var vm: NetworkingProbeViewModel
    @State private var locations: [Location] = []
    @State private var selectedLocation = "spb" // Дефолтный город
    
    @State private var categories: [Category] = []
    @State private var selectedCategory: String? = nil
    
    init(eventService: EventServiceProtocol = EventService()) {
        _vm = StateObject(wrappedValue: NetworkingProbeViewModel(eventService: eventService))
    }
    
    var body: some View {
        List {
            citySection
            categoriesSection
            errorSection
            eventsSection
        }
        .overlay(loadingOverlay)
        .navigationTitle("Networking Probe")
        .task {
            await loadInitialData()
        }
        .refreshable {
            await vm.loadInitial(location: selectedLocation, category: selectedCategory)
        }
    }
    
    // MARK: - Sections
    
    @ViewBuilder
    private var citySection: some View {
        Section {
            Menu {
                ForEach(locations, id: \.slug) { location in
                    Button(location.name) {
                        selectedLocation = location.slug
                        Task {
                            await vm.loadInitial(
                                location: location.slug,
                                category: selectedCategory
                            )
                        }
                    }
                }
            } label: {
                HStack {
                    Label("Город", systemImage: "location")
                    Spacer()
                    Text(currentCityName)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    
    @ViewBuilder
    private var categoriesSection: some View {
        Section {
            CategoryScrollView(
                categories: categories,
                selectedCategory: $selectedCategory,
                onCategorySelected: { category in
                    await vm.loadInitial(
                        location: selectedLocation,
                        category: category
                    )
                }
            )
            .listRowInsets(EdgeInsets())
            .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    private var errorSection: some View {
        if let err = vm.errorText {
            Section {
                Text(err).foregroundStyle(.red)
            }
        }
    }
    
    @ViewBuilder
    private var eventsSection: some View {
        EventsListView(
            events: vm.events,
            nextPageURL: vm.nextPageURL,
            isLoading: vm.isLoading,
            onLoadMore: vm.loadNextPage
        )
    }
    
    @ViewBuilder
    private var loadingOverlay: some View {
        if vm.events.isEmpty && vm.isLoading {
            ProgressView("Loading…")
        }
    }
    
    
    // MARK: - Computed Properties
    
    private var currentCityName: String {
        locations.first { $0.slug == selectedLocation }?.name ?? "Санкт-Петербург"
    }
    
    // MARK: - Methods
    
    private func loadInitialData() async {
        await loadLocations()
        await loadCategories()
        
        if vm.events.isEmpty {
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
    
    private func loadCategories() async {
        do {
            let service = CategoryService()
            self.categories = try await service.fetchCategories()
        } catch {
            print("❌ Failed to load categories: \(error)")
        }
    }
}
