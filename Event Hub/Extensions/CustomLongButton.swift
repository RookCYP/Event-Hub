//
//  Buttons.swift
//  Event Hub
//
//  Created by Валентин on 09.09.2025.
//

import SwiftUI

struct CustomLongButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let style: ButtonStyle
    let isLoading: Bool
    
    enum ButtonStyle {
        case primary
        case secondary
        case lists
    }
    
    init(
        title: String,
        icon: String? = nil,
        style: ButtonStyle = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: action) {
                ZStack {
                    Text(title)
                        .fontWeight(.semibold)
                        .padding()
                    
                    HStack{
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                            .padding(6)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.2))
                            )
                            .padding(.trailing, 13)
                    }
                }
                .foregroundColor(.white)
                .frame(width: style == .primary ? geometry.size.width * 0.8 : geometry.size.width * 0.5)
                .background(Color(red: 89/255, green: 105/255, blue: 246/255))
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(height: 50)
        .padding(.vertical, 30)
        .disabled(isLoading)
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return .black
        case .lists:
            return .black
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .blue
        case .secondary:
            return .white
         case .lists:
            return .black
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary:
            return .clear
        case .secondary:
            return .gray.opacity(0.3)
        case .lists:
            return .clear
}
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary:
            return 0
        case .secondary:
            return 1
        case .lists:
            return 0
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CustomLongButton(
            title: "SIGN IN",
            icon: "arrow.right",
            style: .primary,
            action: {}
        )
        
        CustomLongButton(
            title: "READ",
            icon: "arrow.right",
            style: .lists,
            action: {}
        )
        
        CustomLongButton(
            title: "Loading...",
            style: .primary,
            isLoading: true,
            action: {}
        )
    }
    .padding()
}
