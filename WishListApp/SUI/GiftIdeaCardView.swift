import SwiftUI
import RealmSwift

struct GiftIdeaCardView: View {
    @ObservedRealmObject var idea: GiftIdeaObject
    var onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: idea.imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(20)
                    .frame(height: 120)
                    .foregroundColor(.accent)
                    .frame(maxWidth: .infinity)
                    .background(Color.cardBackground)
                
                Button(action: onAdd) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.accent)
                        .background(Circle().fill(Color.appBackground))
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(idea.title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)
                    .frame(height: 40, alignment: .top) // Для выравнивания высоты
                
                Text(String(format: "$%.2f", idea.price))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.cardBackground.opacity(0.5))
        .cornerRadius(16)
        .clipped()
    }
}
