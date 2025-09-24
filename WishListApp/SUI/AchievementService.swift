import Foundation
import RealmSwift

// Enum для удобного и безопасного обращения к ачивкам
enum AchievementCode: String, CaseIterable {
    case firstWishlist = "FIRST_WISHLIST"
    case fiveGifts = "FIVE_GIFTS"
    case tenGifts = "TEN_GIFTS"
    case firstGiftPurchased = "FIRST_GIFT_PURCHASED"
    case shoppingSpree = "SHOPPING_SPREE_25"
    case perfectionist = "PERFECTIONIST_3" // Complete 3 wishlists
    
    var title: String {
        switch self {
        case .firstWishlist: return "First Step"
        case .fiveGifts: return "Gift Planner"
        case .tenGifts: return "Gift Hunter"
        case .firstGiftPurchased: return "First Gift"
        case .shoppingSpree: return "Shopping Spree"
        case .perfectionist: return "Perfectionist"
        }
    }
    
    var description: String {
        switch self {
        case .firstWishlist: return "Create your first wishlist"
        case .fiveGifts: return "Add 5 gifts to your lists"
        case .tenGifts: return "Add 10 gifts to your lists"
        case .firstGiftPurchased: return "Mark your first gift as purchased"
        case .shoppingSpree: return "Purchase 25 gifts in total"
        case .perfectionist: return "Complete 3 full wishlists"
        }
    }
    
    var goal: Int {
        switch self {
        case .firstWishlist: return 1
        case .fiveGifts: return 5
        case .tenGifts: return 10
        case .firstGiftPurchased: return 1
        case .shoppingSpree: return 25
        case .perfectionist: return 3
        }
    }
}

// Сервис для управления ачивками
class AchievementService {
    static let shared = AchievementService()
    private let realm = RealmManager.shared.realm
    
    private init() {
        seedAchievementsIfNeeded()
    }
    
    // 1. Создание ачивок в базе при первом запуске
    private func seedAchievementsIfNeeded() {
        if realm.objects(AchievementObject.self).isEmpty {
            try? realm.write {
                for code in AchievementCode.allCases {
                    let achievement = AchievementObject()
                    achievement.code = code.rawValue
                    achievement.title = code.title
                    achievement.goal = code.goal
                    realm.add(achievement)
                }
            }
            print("Achievements seeded.")
        }
    }
    
    // 2. Метод для обновления прогресса
    func updateProgress(for code: AchievementCode, progress: Int) {
        guard let achievement = realm.objects(AchievementObject.self).where({ $0.code == code.rawValue }).first else {
            return
        }
        
        // Обновляем, только если ачивка еще не разблокирована
        if !achievement.isUnlocked {
            try? realm.write {
                achievement.progress = min(progress, achievement.goal) // Не даем прогрессу уйти за цель
                if achievement.progress >= achievement.goal {
                    achievement.isUnlocked = true
                    achievement.unlockedAt = Date()
                    print("Achievement unlocked: \(code.title)")
                    // Здесь можно будет затриггерить анимацию kanga_party
                }
            }
        }
    }
    
    // 3. Метод для инкрементального обновления
    func incrementProgress(for code: AchievementCode, by amount: Int = 1) {
        guard let achievement = realm.objects(AchievementObject.self).where({ $0.code == code.rawValue }).first else {
            return
        }
        if !achievement.isUnlocked {
            updateProgress(for: code, progress: achievement.progress + amount)
        }
    }
}
