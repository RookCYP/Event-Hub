//
//  ScreenImage.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/13/25.
//

import SwiftUI

struct ScreenImage: View {
    let image: Image
    
    private let opacityGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: .white, location: 0.0),
            .init(color: .white, location: 0.65),
            .init(color: .clear, location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .mask(
                opacityGradient
            )
    }
}

#Preview {
    ScreenImage(image: Image(.iPhoneX))
}
