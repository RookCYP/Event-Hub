//
//  ContentViewTest.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//

import SwiftUI

struct ContentViewTest: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Button { authManager.signOut() } label: {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.1) : .black)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, 20)
                }

                NavigationLink("Open Networking Probe") {
                    NetworkingProbeView()
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 20)
                
                Button("Test Locations") {
                    Task {
                        do {
                            let service = LocationService()
                            let locations = try await service.fetchLocations()
                            print("📍 Loaded \(locations.count) locations")
                            for loc in locations.prefix(5) {
                                print("  - \(loc.name) (\(loc.slug))")
                            }
                        } catch {
                            print("❌ Location error: \(error)")
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("Home")
        }
    }
}
