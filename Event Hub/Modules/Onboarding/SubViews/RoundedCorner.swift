//
//  RoundedCorner.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/13/25.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    RoundedCorner(radius: 48, corners: [.topLeft, .topRight])
        .fill(Color(red: 89/255, green: 105/255, blue: 246/255))
        .frame(height: 200)
        .padding()
        
}
