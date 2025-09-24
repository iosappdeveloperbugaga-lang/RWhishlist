import Foundation
import RealmSwift
import Combine

protocol WishlistRepositoryProtocol {
    func fetchWishlists() -> AnyPublisher<[WishlistObject], Error>
    func addWishlist(name: String, eventDate: Date, note: String?) throws
    func deleteWishlist(id: ObjectId) throws
    func addGiftToWishlist(wishlistId: ObjectId, giftIdea: GiftIdeaObject) throws
    func toggleGiftPurchasedStatus(giftId: String, inWishlist wishlistId: ObjectId) throws
    // Измененный метод
    func addManualGiftToWishlist(wishlistId: ObjectId, title: String, price: Double?, photoData: Data?) throws
    func deleteGift(withId giftId: String, fromWishlist wishlistId: ObjectId) throws
}

class WishlistRepository: WishlistRepositoryProtocol {
    
    private let realm = RealmManager.shared.realm
    
    // ... существующие методы fetchWishlists, addWishlist, deleteWishlist ...
    
    private func updateTotalGiftCountAchievements() {
        let totalGifts = realm.objects(WishlistObject.self).flatMap { $0.gifts }.count
        AchievementService.shared.updateProgress(for: .fiveGifts, progress: totalGifts)
        AchievementService.shared.updateProgress(for: .tenGifts, progress: totalGifts)
    }
    
    func addGiftToWishlist(wishlistId: ObjectId, giftIdea: GiftIdeaObject) throws {
        guard let wishlist = realm.object(ofType: WishlistObject.self, forPrimaryKey: wishlistId) else {
            throw NSError(domain: "WishlistRepo", code: 404, userInfo: [NSLocalizedDescriptionKey: "Wishlist not found"])
        }
        
        let newGift = GiftItemObject()
        newGift.title = giftIdea.title
        newGift.price = giftIdea.price
        newGift.category = giftIdea.category
        newGift.imageName = giftIdea.imageName
        
        try RealmManager.shared.write { realm in
            wishlist.gifts.append(newGift)
            wishlist.updatedAt = Date()
        }
        updateTotalGiftCountAchievements()
    }
    
    // --- ИЗМЕНЕННЫЙ МЕТОД ---
    func addManualGiftToWishlist(wishlistId: ObjectId, title: String, price: Double?, photoData: Data?) throws {
        guard let wishlist = realm.object(ofType: WishlistObject.self, forPrimaryKey: wishlistId) else {
            throw NSError(domain: "WishlistRepo", code: 404, userInfo: [NSLocalizedDescriptionKey: "Wishlist not found"])
        }
        
        let newGift = GiftItemObject()
        newGift.title = title
        newGift.price = price
        newGift.category = "Manual"
        newGift.imageName = "giftcard" // SF Symbol
        newGift.photoData = photoData // Сразу сохраняем фото
        
        try RealmManager.shared.write { realm in
            wishlist.gifts.append(newGift)
            wishlist.updatedAt = Date()
        }
        updateTotalGiftCountAchievements()
    }
    
    func deleteGift(withId giftId: String, fromWishlist wishlistId: ObjectId) throws {
        guard let wishlist = realm.object(ofType: WishlistObject.self, forPrimaryKey: wishlistId),
              let giftIndex = wishlist.gifts.firstIndex(where: { $0.id == giftId }) else {
            return
        }
        
        try RealmManager.shared.write { realm in
            wishlist.gifts.remove(at: giftIndex)
        }
        updateTotalGiftCountAchievements()
    }
    
    func toggleGiftPurchasedStatus(giftId: String, inWishlist wishlistId: ObjectId) throws {
        guard let wishlist = realm.object(ofType: WishlistObject.self, forPrimaryKey: wishlistId),
              let gift = wishlist.gifts.first(where: { $0.id == giftId }) else {
            return
        }
        
        try realm.write {
            gift.isPurchased.toggle()
        }
        
        let totalPurchased = realm.objects(WishlistObject.self).flatMap { $0.gifts }.filter { $0.isPurchased }.count
        AchievementService.shared.updateProgress(for: .firstGiftPurchased, progress: totalPurchased)
        AchievementService.shared.updateProgress(for: .shoppingSpree, progress: totalPurchased)
        
        let completedWishlists = realm.objects(WishlistObject.self).filter { !$0.gifts.isEmpty && $0.purchaseProgress == 1.0 }.count
        AchievementService.shared.updateProgress(for: .perfectionist, progress: completedWishlists)
    }

    func fetchWishlists() -> AnyPublisher<[WishlistObject], Error> {
        let results = realm.objects(WishlistObject.self).sorted(byKeyPath: "eventDate", ascending: true)
        
        return results.collectionPublisher
            .map { Array($0) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func addWishlist(name: String, eventDate: Date, note: String?) throws {
        let newWishlist = WishlistObject()
        newWishlist.name = name
        newWishlist.eventDate = eventDate
        newWishlist.note = note
        
        try RealmManager.shared.write { realm in
            realm.add(newWishlist)
        }
        AchievementService.shared.incrementProgress(for: .firstWishlist)
    }
    
    func deleteWishlist(id: ObjectId) throws {
        guard let wishlistToDelete = realm.object(ofType: WishlistObject.self, forPrimaryKey: id) else {
            return
        }
        
        try RealmManager.shared.write { realm in
            realm.delete(wishlistToDelete)
        }
    }
}
