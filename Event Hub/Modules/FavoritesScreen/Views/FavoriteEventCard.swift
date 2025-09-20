//
//  FavoriteEventCard.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 20.09.25.
//

// /Modules/Favorites/Views/FavoriteEventCard.swift
// FavoriteEventCard.swift (async/await версия)
import SwiftUI
import Kingfisher

struct FavoriteEventCard: View {
    let favorite: FavoriteEvent
    let onDelete: () -> Void
    
    @State private var loadedImage: Image = Image(systemName: "photo.fill")
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    
    private let deleteButtonWidth: CGFloat = 80
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Кнопка удаления под карточкой
            HStack {
                Spacer()
                
                Button(action: onDelete) {
                    VStack {
                        Image(systemName: "trash")
                            .font(.title2)
                        Text("Delete")
                            .font(.caption)
                    }
                    .foregroundColor(.red)
                    .frame(width: deleteButtonWidth)
                }
                .background(.white)
            }
            
            // Сама карточка события
            EventCardView(
                image: loadedImage,
                date: favorite.formattedDateString,
                title: favorite.displayTitle,
                location: favorite.formattedLocation,
                isFavorite: true
            )
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offset = max(value.translation.width, -deleteButtonWidth)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.width < -50 {
                                offset = -deleteButtonWidth
                                isSwiped = true
                            } else {
                                offset = 0
                                isSwiped = false
                            }
                        }
                    }
            )
            .task {
                await loadImage()
            }
        }
    }
    
    @MainActor
    private func loadImage() async {
        guard let urlString = favorite.imageURL,
              let url = URL(string: urlString) else { return }
        
        do {
            let imageResult = try await KingfisherManager.shared.retrieveImage(with: url)
            loadedImage = Image(uiImage: imageResult.image)
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}
