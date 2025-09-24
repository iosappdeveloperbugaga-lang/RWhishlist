import SwiftUI

struct AchievementsView: View {
    @StateObject private var viewModel = AchievementsViewModel()
    @State private var showSettingsSheet = false // Новое состояние
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header с маскотом и прогрессом
                        VStack {
                            Image(systemName: "figure.wave") // kanga_party
                                .resizable().scaledToFit().frame(height: 100)
                                .foregroundColor(.accent)
                            Text("Keep Going!").font(.title.bold()).foregroundColor(.textPrimary)
                            Text("You're doing amazing at gift planning").foregroundColor(.textSecondary)
                        }
                        
                        // Статистика
                        HStack(spacing: 16) {
                            StatView(count: viewModel.earnedCount, label: "Earned")
                            StatView(count: viewModel.inProgressCount, label: "In Progress")
                            StatView(count: viewModel.lockedCount, label: "Locked")
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(16)
                        
                        // Сетка ачивок
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.achievements) { achievement in
                                AchievementCardView(achievement: achievement)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            // --- НОВЫЙ TOOLBAR ITEM ---
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSettingsSheet = true }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundColor(.accent)
                    }
                }
            }
            // --- НОВЫЙ SHEET MODIFIER ---
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView()
            }
        }
    }
}

// Вспомогательное View для статистики (без изменений)
struct StatView: View {
    let count: Int
    let label: String
    
    var body: some View {
        VStack {
            Text("\(count)")
                .font(.title2.bold())
                .foregroundColor(.accent)
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}
