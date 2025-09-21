//
//  EventDetailsView.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/19/25.
//

import SwiftUI

struct EventDetailsView: View {
    @StateObject private var vm: EventDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    let eventId: String
    let eventTitle: String?
    
    init(eventId: String, eventTitle: String? = nil) {
        self.eventId = eventId
        self.eventTitle = eventTitle
        
        // Создаем ViewModel с правильными параметрами
        let link = "https://youreventhub.app/event/\(eventId)"
        let message = "\(eventTitle ?? "Amazing Event") — don't miss it!"
        
        self._vm = StateObject(wrappedValue: EventDetailsViewModel(
            eventId: eventId,
            link: link,
            message: message
        ))
    }

    var body: some View {
        VStack {
            // Изображение с кнопками
            HeaderImageWithControls(
                image: Image(.concert),
                isFavorite: vm.isFavorite,
                onBack: { dismiss() },
                onToggleFavorite: { vm.toggleFavorite() },
                onShare: { vm.showShareSheet = true }
            )

            ScrollView(showsIndicators: false) {
                
                // Контент
                VStack(alignment: .leading, spacing: 16) {
                    Text(vm.title)
                        .font(.largeTitle)

                    HStack {
                        Image(.dateIcon).resizable().frame(width: 48, height: 48)
                        VStack(alignment: .leading) {
                            Text(vm.dateTitle).font(.headline)
                            Text(vm.dateSubtitle).font(.subheadline)
                        }
                    }
                    HStack {
                        Image(.locationblueIcon).resizable().frame(width: 48, height: 48)
                        VStack(alignment: .leading) {
                            Text(vm.placeTitle).font(.headline)
                            Text(vm.placeSubtitle).font(.subheadline)
                        }
                    }
                    HStack {
                        Image(.imageIcon).resizable().frame(width: 48, height: 48)
                        VStack(alignment: .leading) {
                            Text(vm.organizerTitle).font(.headline)
                            Text(vm.organizerSubtitle).font(.subheadline)
                        }
                    }

                    Text("About Event").font(.title)
                    Text(vm.aboutText)
                }
                .padding(.top, 30)
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 21)
        }
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $vm.showShareSheet) {
            ShareGridView(title: "Share with friends",
                          targets: vm.shareTargets,
                          link: vm.link,
                          message: vm.message)
            .presentationDetents([.fraction(0.5)])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(35)
        }
    }
}

struct HeaderImageWithControls: View {
    let image: Image
    let isFavorite: Bool
    let onBack: () -> Void
    let onToggleFavorite: () -> Void
    let onShare: () -> Void

    var body: some View {
        ZStack {
            image
                .resizable()
                .scaledToFill()
                .frame(height: 244)
                .clipped()
        }
        // Навбар-кнопки (Back слева, Bookmark справа) — в верхней зоне
        .overlay(alignment: .top) {
            HStack {
                backButton
                Spacer()
                bookmarkButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
        }
        // Share остаётся внизу справа
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
