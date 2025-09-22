//
//  EventDetailsView.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/19/25.
//

import SwiftUI
import Kingfisher

struct EventDetailsView: View {
    @StateObject private var vm: EventDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    let eventId: String
    
    init(eventId: String, eventTitle: String? = nil) {
        self.eventId = eventId
        // eventTitle - загружаем из API
        self._vm = StateObject(wrappedValue: EventDetailsViewModel(eventId: eventId))
    }
    
    var body: some View {
        ZStack {
            if vm.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
            } else if let error = vm.errorMessage {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text(error)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("Try Again") {
                        Task {
                            await vm.loadEventDetails()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else if vm.event != nil {
                VStack {
                    // Изображение с кнопками
                    HeaderImageWithControls(
                        imageURL: vm.event?.primaryImageURL,
                        isFavorite: vm.isFavorite,
                        onBack: { dismiss() },
                        onToggleFavorite: { vm.toggleFavorite() },
                        onShare: { vm.showShareSheet = true }
                    )
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(vm.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            // Информация о событии
                            EventInfoRow(
                                icon: Image(.dateIcon),
                                title: vm.dateTitle,
                                subtitle: vm.dateSubtitle
                            )
                            
                            EventInfoRow(
                                icon: Image(.locationblueIcon),
                                title: vm.placeTitle,
                                subtitle: vm.placeSubtitle
                            )
                            
                            EventInfoRow(
                                icon: Image(.imageIcon),
                                title: vm.organizerTitle,
                                subtitle: vm.organizerSubtitle
                            )
                            
                            // Цена и возрастные ограничения
                            if let event = vm.event {
                                HStack {
                                    if event.isFree == true {
                                        Label("Free", systemImage: "gift")
                                            .foregroundColor(.green)
                                    } else if let price = event.price, !price.isEmpty {
                                        Label(price, systemImage: "rublesign.circle")
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Spacer()
                                    
                                    if let ageRestriction = event.ageRestriction?.text {
                                        Text(ageRestriction)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.red.opacity(0.1))
                                            .foregroundColor(.red)
                                            .cornerRadius(4)
                                    }
                                }
                                .padding(.top, 8)
                            }
                            
                            Text("About Event")
                                .font(.title)
                                .padding(.top)
                            
                            Text(vm.aboutText)
                                .font(.body)
                        }
                        .padding(.horizontal, 21)
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                    }
                }
                .ignoresSafeArea(edges: .top)
            }
        }
        .sheet(isPresented: $vm.showShareSheet) {
            ShareGridView(
                title: "Share with friends",
                targets: vm.shareTargets,
                link: vm.link,
                message: vm.message
            )
            .presentationDetents([.fraction(0.5)])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(35)
        }
    }
}

// Вспомогательный компонент для строки информации
struct EventInfoRow: View {
    let icon: Image
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(alignment: .top) {
            icon
                .resizable()
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct HeaderImageWithControls: View {
    let imageURL: URL?
    let isFavorite: Bool
    let onBack: () -> Void
    let onToggleFavorite: () -> Void
    let onShare: () -> Void
    
    private var defaultHeader: some View {
        Image("International Band Mu")
            .resizable()
            .scaledToFill()
            .frame(height: 244)
            .clipped()
    }
    
    var body: some View {
        ZStack {
            if let url = imageURL {
                KFImage(url)
                    .placeholder { defaultHeader } // пока грузится
                    .onFailure { _ in }            // при ошибке — placeholder уже показан
                    .resizable()
                    .scaledToFill()
                    .frame(height: 244)
                    .clipped()
            } else {
                defaultHeader
            }
        }
        // затемнение для контраста кнопок 
        .overlay(
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.35), .clear]),
                startPoint: .top, endPoint: .center
            )
        )
        .overlay(alignment: .top) {
            HStack {
                backButton
                Spacer()
                bookmarkButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
        }
        .overlay(alignment: .bottomTrailing) {
            Button(action: onShare) {
                Image(.shareIcon)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .padding(10)
            }
            .padding(20)
        }
    }
    
    // MARK: - Buttons
    
    private var backButton: some View {
        Button(action: onBack) {
            HStack(spacing: 8) {
                Image(.Icons.arrowLeft)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .accessibilityHidden(true)
                
                Text("Event Details")
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(minWidth: 44, minHeight: 44, alignment: .leading)  // гарантируем hit target
            .contentShape(Capsule())
            
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(.isButton)
    }
    
    private var bookmarkButton: some View {
        Button(action: onToggleFavorite) {
            Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(10) // такой же внутренний паддинг, как у Share
        }
        .foregroundColor(.white)
        .background(
            Circle()
                .fill(Color.black.opacity(0.30))
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.20), lineWidth: 0.5)
                )
        )
        .contentShape(Circle())
    }
}
