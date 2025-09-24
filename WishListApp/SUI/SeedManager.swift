import Foundation
import RealmSwift

// Простая структура для декодирования JSON
struct GiftIdeaSeed: Codable {
    let title: String
    let price: Double
    let category: String
    let imageName: String
}

class SeedManager {
    
    private static let seedFlagKey = "isDataSeeded"
    
    static func seedInitialDataIfNeeded() {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: seedFlagKey) else {
            print("Data already seeded. Skipping.")
            return
        }
        
        print("Seeding initial gift ideas...")
        
        guard let url = Bundle.main.url(forResource: "gift_ideas_seed", withExtension: "json") else {
            print("Error: gift_ideas_seed.json not found.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let ideas = try JSONDecoder().decode([GiftIdeaSeed].self, from: data)
            
            let realm = RealmManager.shared.realm
            try realm.write {
                for idea in ideas {
                    let ideaObject = GiftIdeaObject()
                    ideaObject.title = idea.title
                    ideaObject.price = idea.price
                    ideaObject.category = idea.category
                    ideaObject.imageName = idea.imageName
                    realm.add(ideaObject)
                }
            }
            
            defaults.set(true, forKey: seedFlagKey)
            print("Successfully seeded \(ideas.count) gift ideas.")
            
        } catch {
            print("Error seeding data: \(error)")
        }
    }
}
