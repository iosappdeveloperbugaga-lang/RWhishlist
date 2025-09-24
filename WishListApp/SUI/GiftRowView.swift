import SwiftUI
import RealmSwift
import PhotosUI

struct GiftRowView: View {
    @ObservedRealmObject var gift: GiftItemObject
    var onTogglePurchased: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onTogglePurchased) {
                Image(systemName: gift.isPurchased ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(gift.isPurchased ? .accent : .textSecondary)
            }
            .buttonStyle(.plain) // Важно для предотвращения срабатывания на всю ячейку
            
            // --- БЛОК ОТОБРАЖЕНИЯ ФОТО (без пикера) ---
            if let photoData = gift.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            // --- КОНЕЦ БЛОКА ---
            
            VStack(alignment: .leading) {
                Text(gift.title)
                    .foregroundColor(.textPrimary)
                    .strikethrough(gift.isPurchased, color: .textSecondary)
                
                if let price = gift.price {
                    Text(String(format: "$%.2f", price))
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
