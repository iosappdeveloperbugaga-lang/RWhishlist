import SwiftUI

struct StyledTextField: View {
    let placeholder: String
    @Binding var text: String
    let iconName: String?
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .foregroundColor(.textPrimary)
                .tint(.accent)
            
            if let iconName = iconName {
                Image(systemName: iconName)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.textSecondary.opacity(0.3), lineWidth: 1)
        )
    }
}
