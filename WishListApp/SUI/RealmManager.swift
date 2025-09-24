import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    private let schemaVersion: UInt64 = 2
    
    private init() {}
    
    var realm: Realm {
        do {
            let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    print("Migrating Realm schema from v1 to v2")
                }
            })
            Realm.Configuration.defaultConfiguration = config
            
            return try Realm()
        } catch {
            fatalError("Failed to configure and open Realm: \(error)")
        }
    }
    
    func write<T>(_ block: (Realm) throws -> T) throws -> T {
        let realm = self.realm
        if realm.isInWriteTransaction {
            return try block(realm)
        } else {
            return try realm.write {
                try block(realm)
            }
        }
    }
    
    // --- НОВЫЙ МЕТОД ---
    func deleteAllData() {
        do {
            try realm.write {
                realm.deleteAll()
            }
            print("All Realm data has been deleted.")
            
            // Сбрасываем флаги сидинга, чтобы данные загрузились заново
            UserDefaults.standard.set(false, forKey: "isDataSeeded")
            SeedManager.seedInitialDataIfNeeded()
            
            // AchievementService сам проверяет, нужно ли сидить данные
            _ = AchievementService.shared
            
            print("Initial data has been re-seeded.")
            
        } catch {
            print("Error deleting all data: \(error)")
        }
    }
}



class GiftItemObject: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var id = UUID().uuidString
    @Persisted var title: String = ""
    @Persisted var price: Double?
    @Persisted var category: String = ""
    @Persisted var imageName: String?
    @Persisted var isPurchased: Bool = false
    @Persisted var photoData: Data? // <-- НОВОЕ ПОЛЕ
}


class WishlistObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var eventDate: Date
    @Persisted var note: String?
    @Persisted var createdAt: Date = Date()
    @Persisted var updatedAt: Date = Date()
    @Persisted var gifts: List<GiftItemObject>
}

class GiftIdeaObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var price: Double
    @Persisted var category: String
    @Persisted var imageName: String
}

class EventObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var date: Date
    @Persisted var linkedWishlistId: ObjectId?
}

class AchievementObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var code: String // Уникальный код ачивки, e.g., "FIRST_WISHLIST"
    @Persisted var title: String
    @Persisted var progress: Int = 0
    @Persisted var goal: Int = 1
    @Persisted var isUnlocked: Bool = false
    @Persisted var unlockedAt: Date?
    
    override static func indexedProperties() -> [String] {
        return ["code"] // Индексируем для быстрого поиска
    }
}
