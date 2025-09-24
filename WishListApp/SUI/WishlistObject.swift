import Foundation

extension WishlistObject {
    var purchasedGiftsCount: Int {
        gifts.filter { $0.isPurchased }.count
    }
    
    var totalGiftsCount: Int {
        gifts.count
    }
    
    var purchaseProgress: Double {
        guard totalGiftsCount > 0 else { return 0.0 }
        return Double(purchasedGiftsCount) / Double(totalGiftsCount)
    }
}
