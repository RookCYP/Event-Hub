//
//  AuthTextField.swift
//  Event Hub
//
//  Created by Rook on 07.09.2025.
//

import SwiftUI

struct AuthTextField: View {
    let title: String
    let icon: String
    @Binding var text: String
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let autocapitalization: UITextAutocapitalizationType
    
    @State private var showPassword = false
    
    init(
        title: String,
        icon: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: UITextAutocapitalizationType = .sentences
    ) {
        self.title = title
        self.icon = icon
        self._text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
    }
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            if isSecure && !showPassword {
                SecureField(title, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
            } else {
                TextField(title, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .keyboardType(keyboardType)
                    .autocapitalization(autocapitalization)
                    .disableAutocorrection(keyboardType == .emailAddress)
            }
            
            if isSecure {
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 20) {
        AuthTextField(
            title: "Email",
            icon: "envelope",
            text: .constant(""),
            keyboardType: .emailAddress,
            autocapitalization: .none
        )
        
        AuthTextField(
            title: "Password",
            icon: "lock",
            text: .constant(""),
            isSecure: true
        )
    }
    .padding()
}
