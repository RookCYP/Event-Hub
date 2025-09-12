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
    @State private var logText: String = ""
    
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
                        logText = "Loading locations...\n"
                        do {
                            let service = LocationService()
                            let locations = try await service.fetchLocations()
                            logText += "📍 Loaded \(locations.count) locations:\n"
                            for loc in locations {
                                logText += "  - \(loc.name) (\(loc.slug))\n"
                            }
                        } catch {
                            logText += "❌ Location error: \(error)\n"
                        }
                    }
                }
                .buttonStyle(.bordered)
                .padding(.horizontal, 20)
                
                // Текстовое поле для логов
                ScrollView {
                    Text(logText.isEmpty ? "Logs will appear here..." : logText)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(logText.isEmpty ? .secondary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .frame(maxHeight: 200)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationTitle("Home")
        }
    }
}
