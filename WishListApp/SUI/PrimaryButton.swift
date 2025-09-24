//
//  PrimaryButton.swift
//  WishListApp
//
//  Created by D K on 23.09.2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon) // Используем SF Symbols для гибкости
                }
                Text(title)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accent)
            .foregroundColor(.appBackground)
            .cornerRadius(16)
        }
        .scaleEffect(0.98) // Легкая анимация при нажатии
        .animation(.easeOut(duration: 0.2), value: 0.98)
        .accessibilityLabel(title)
    }
}
