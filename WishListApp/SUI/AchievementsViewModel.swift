import Foundation
import Combine
import RealmSwift

class AchievementsViewModel: ObservableObject {
    @Published var achievements: [AchievementObject] = []
    
    @Published var earnedCount: Int = 0
    @Published var inProgressCount: Int = 0
    @Published var lockedCount: Int = 0
    
    private var notificationToken: NotificationToken?
    private let realm = RealmManager.shared.realm
    
    init() {
        // Убедимся, что сервис инициализирован
        _ = AchievementService.shared
        observeAchievements()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    private func observeAchievements() {
        let results = realm.objects(AchievementObject.self).sorted(byKeyPath: "title")
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            
            let achievementsArray = Array(results)
            self.achievements = achievementsArray
            self.updateCounts(with: achievementsArray)
        }
    }
    
    private func updateCounts(with achievements: [AchievementObject]) {
        earnedCount = achievements.filter { $0.isUnlocked }.count
        inProgressCount = achievements.filter { !$0.isUnlocked && $0.progress > 0 }.count
        lockedCount = achievements.filter { !$0.isUnlocked && $0.progress == 0 }.count
    }
}
