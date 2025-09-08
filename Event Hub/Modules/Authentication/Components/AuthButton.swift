//
//  AuthButton.swift
//  Event Hub
//
//  Created by Rook on 07.09.2025.
//

import SwiftUI

struct AuthButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let style: ButtonStyle
    let isLoading: Bool
    
    enum ButtonStyle {
        case primary
        case secondary
        case google
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
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .medium))
                    }
                    
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return .white
        case .secondary:
            return .black
        case .google:
            return .black
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .blue
        case .secondary:
            return .white
        case .google:
            return .white
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary:
            return .clear
        case .secondary:
            return .gray.opacity(0.3)
        case .google:
            return .gray.opacity(0.3)
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .primary:
            return 0
        case .secondary:
            return 1
        case .google:
            return 1
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AuthButton(
            title: "SIGN IN",
            icon: "arrow.right",
            style: .primary,
            action: {}
        )
        
        AuthButton(
            title: "Login with Google",
            icon: "globe",
            style: .google,
            action: {}
        )
        
        AuthButton(
            title: "Loading...",
            style: .primary,
            isLoading: true,
            action: {}
        )
    }
    .padding()
}
