//
//  ExploreView.swift
//  Event Hub
//
//  Created by Валентин on 14.09.2025.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var router: Router
    var body: some View {
        VStack {
            Text("This is Explore Screen2")
            Button {
                router.goTo(to: .detailScreen)
            } label: {
                Text("Go to DetailScreen")
            }
        }
    }
}

#Preview {
    ExploreView()
}
