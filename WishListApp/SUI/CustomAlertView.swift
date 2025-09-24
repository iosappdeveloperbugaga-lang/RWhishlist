import SwiftUI

struct CustomAlertView: View {
    let systemImageName: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImageName)
                .font(.system(size: 50))
                .foregroundColor(.accent)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
        .background(Material.regular) // Используем Material для эффекта размытия
        .background(Color.cardBackground.opacity(0.8))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 20)
        .padding(40)
    }
}
