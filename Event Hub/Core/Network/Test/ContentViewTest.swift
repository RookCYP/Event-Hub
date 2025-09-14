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
                
                // Endpoint "/places/" возвращает объект с пагинацией (как и "/events/").
                //                Это может пригодиться для:
                //                Карт - показать места проведения событий
                //                Фильтрации - "События рядом с метро Адмиралтейская"
                //                Навигации - построить маршрут до места
                Button("Test Places") {
                    Task {
                        logText = "Loading places for SPb...\n"
                        do {
                            
                            let service = PlaceService()
                            let response = try await service.fetchPlaces(
                                location: "spb",
                                pageSize: 10
                            )
                            logText += "📍 Found \(response.count) places total\n"
                            logText += "📍 Showing first \(response.results.count):\n"
                            
                            for place in response.results.prefix(5) {
                                logText += "  - \(place.title)\n"
                                if let address = place.address {
                                    logText += "    📍 \(address)\n"
                                }
                                if let subway = place.subway, !subway.isEmpty {
                                    logText += "    🚇 \(subway)\n"
                                }
                            }
                        } catch {
                            logText += "❌ Places error: \(error)\n"
                        }
                    }
                }
                .buttonStyle(.bordered)
                .padding(.horizontal, 20)
                
                Button("Test Search") {
                    Task {
                        logText = "Тестируем поиск...\n"
                        do {
                            let service = SearchService()
                            
                            // Тест 1: Поиск событий
                            logText += "\n🔍 Поиск событий 'концерт':\n"
                            let eventResults = try await service.searchEvents(
                                query: "концерт",
                                location: "spb"
                            )
                            logText += "  Найдено событий: \(eventResults.count)\n"
                            for result in eventResults.results.prefix(3) {
                                logText += "  - \(result.title)\n"
                            }
                            
                            // Тест 2: Поиск мест
                            logText += "\n📍 Поиск мест 'музей':\n"
                            let placeResults = try await service.searchPlaces(
                                query: "музей",
                                location: "spb"
                            )
                            logText += "  Найдено мест: \(placeResults.count)\n"
                            for result in placeResults.results.prefix(3) {
                                logText += "  - \(result.title)\n"
                            }
                            
                            // Тест 3: Универсальный поиск
                            logText += "\n🔎 Общий поиск 'выставка':\n"
                            let allResults = try await service.searchAll(
                                query: "выставка",
                                location: "spb"
                            )
                            logText += "  Всего результатов: \(allResults.count)\n"
                            let eventCount = allResults.results.filter { $0.ctype == "event" }.count
                            let placeCount = allResults.results.filter { $0.ctype == "place" }.count
                            logText += "  События: \(eventCount), Места: \(placeCount)\n"
                            
                        } catch {
                            logText += "❌ Ошибка поиска: \(error)\n"
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
