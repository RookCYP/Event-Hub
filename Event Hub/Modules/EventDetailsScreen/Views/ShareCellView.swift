//
//  ShareCellView.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/19/25.
//

import SwiftUI

// MARK: - Ячейка сетки

struct ShareCellView: View {
    let target: ShareTarget
    let iconSize: CGFloat
    let isCopyStyle: Bool

    var body: some View {
        VStack(spacing: 6) {
           
                Image(target.iconAssetName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: iconSize, height: iconSize)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            

            Text(target.title)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview("WhatsApp") {
    ShareCellView(target: .whatsapp,
                  iconSize: 40,
                  isCopyStyle: false)
        .padding()
        .background(Color(.systemBackground))
}
