import SwiftUI
import RealmSwift

struct WishlistRowView: View {
    @ObservedRealmObject var wishlist: WishlistObject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(wishlist.name)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                Spacer()
                Text("\(wishlist.purchasedGiftsCount)/\(wishlist.totalGiftsCount) purchased")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.textSecondary)
            }
            
            ProgressView(value: wishlist.purchaseProgress)
                .tint(.accent)
            
            HStack {
                Text(wishlist.eventDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
                Spacer()
                Text("\(wishlist.totalGiftsCount) gifts")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.appBackground)
    }
}
