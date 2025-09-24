import SwiftUI
import RealmSwift

struct AchievementCardView: View {
    @ObservedRealmObject var achievement: AchievementObject
    
    private var progress: Double {
        guard achievement.goal > 0 else { return 0 }
        return Double(achievement.progress) / Double(achievement.goal)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: achievement.isUnlocked ? "star.fill" : "star")
                .font(.largeTitle)
                .foregroundColor(.accent)
            
            Text(achievement.title)
                .font(.headline)
                .foregroundColor(.textPrimary)
            
            if !achievement.isUnlocked {
                ProgressView(value: progress)
                    .tint(.accent)
                Text("\(achievement.progress)/\(achievement.goal)")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            } else {
                Text("Completed!")
                    .font(.caption.bold())
                    .foregroundColor(.accent)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .opacity(achievement.isUnlocked ? 1.0 : 0.7)
    }
}
