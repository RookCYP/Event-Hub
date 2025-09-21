//
//  EventDetalisView.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/19/25.
//

import SwiftUI

struct EventDetalisView: View {
    @StateObject private var vm = EventDetailsViewModel(
        link: "https://youreventhub.app/event/123",
        message: "International Band Music Concert — don’t miss it!"
    )

    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Image(.concert)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 244)
                    .clipped()

                Button { vm.showShareSheet = true } label: {
                    Image(.shareIcon)
                        .resizable()
                        .frame(width: 36, height: 36)
                }
                .padding(20)
            }

            ScrollView(showsIndicators: false) {
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

#Preview {
    EventDetalisView()
}
