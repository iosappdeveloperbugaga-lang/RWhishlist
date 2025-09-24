import SwiftUI
import RealmSwift

struct EventRowView: View {
    @ObservedRealmObject var event: EventObject
    // Мы можем получить вишлист по ID, если он есть
    @State private var linkedWishlist: WishlistObject?
    
    private var daysLeft: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: event.date).day ?? 0
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(event.date.formatted(.dateTime.month(.abbreviated)))
                    .font(.caption.bold())
                    .foregroundColor(.accent)
                Text(event.date.formatted(.dateTime.day()))
                    .font(.title2.bold())
                    .foregroundColor(.textPrimary)
            }
            .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
                Text(daysLeft >= 0 ? "In \(daysLeft) days" : "Event has passed")
                    .font(.subheadline)
                    .foregroundColor(.textSecondary)
                
                if let wishlist = linkedWishlist {
                    HStack {
                        Image(systemName: "gift.fill")
                        Text(wishlist.name)
                    }
                    .font(.caption)
                    .foregroundColor(.accent)
                } else {
                    Text("No wishlist linked")
                        .font(.caption)
                        .foregroundColor(.textSecondary.opacity(0.8))
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
        .onAppear(perform: fetchLinkedWishlist)
    }
    
    private func fetchLinkedWishlist() {
        guard let id = event.linkedWishlistId else {
            self.linkedWishlist = nil
            return
        }
        let realm = RealmManager.shared.realm
        self.linkedWishlist = realm.object(ofType: WishlistObject.self, forPrimaryKey: id)
    }
}
