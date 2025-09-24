import Foundation
import RealmSwift
import Combine
import SwiftUI

class WishlistDetailViewModel: ObservableObject {
    @Published var wishlist: WishlistObject
    @Published var showAddGiftSheet = false
    
    private var repository: WishlistRepositoryProtocol
    private var notificationToken: NotificationToken?
    
    var isWishlistComplete: Bool {
        !wishlist.gifts.isEmpty && wishlist.purchaseProgress == 1.0
    }
    
    init(wishlist: WishlistObject, repository: WishlistRepositoryProtocol = WishlistRepository()) {
        self.wishlist = wishlist
        self.repository = repository
        observeWishlist()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    private func observeWishlist() {
        notificationToken = wishlist.observe { [weak self] change in
            switch change {
            case .change(_, _):
                self?.objectWillChange.send()
            case .deleted:
                self?.notificationToken?.invalidate()
            case .error(let error):
                print("Error observing wishlist: \(error)")
            }
        }
    }
    
    func deleteGift(at offsets: IndexSet) {
        let giftIdsToDelete = offsets.map { wishlist.gifts[$0].id }
        giftIdsToDelete.forEach { id in
            try? repository.deleteGift(withId: id, fromWishlist: wishlist.id)
        }
    }
    
    func togglePurchasedStatus(for gift: GiftItemObject) {
        try? repository.toggleGiftPurchasedStatus(giftId: gift.id, inWishlist: wishlist.id)
    }
    
    // --- ИЗМЕНЕННЫЙ МЕТОД ---
    func addGift(title: String, price: Double?, photoData: Data?) {
        try? repository.addManualGiftToWishlist(
            wishlistId: wishlist.id,
            title: title,
            price: price,
            photoData: photoData
        )
        showAddGiftSheet = false
    }
}
