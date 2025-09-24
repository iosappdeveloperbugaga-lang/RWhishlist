import SwiftUI

struct StartView: View {
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    // Этот код для ContentView остается
    @StateObject private var tabBarManager = TabBarVisibilityManager()
    
    init() {
        // Эти инициализаторы вызываются только один раз при запуске приложения
        SeedManager.seedInitialDataIfNeeded()
        NotificationManager.shared.requestAuthorization()
    }
    
    var body: some View {
        // --- ИСПРАВЛЕННАЯ ЛОГИКА ---
        if hasCompletedOnboarding {
            // Если онбординг пройден, показываем главный экран
            ContentView()
                .environmentObject(tabBarManager)
        } else {
            // Если онбординг не пройден, показываем его
            OnboardingView {
                // Это замыкание будет вызвано при нажатии на "Get Started"
                // Мы явно устанавливаем флаг, что вызовет перерисовку StartView
                self.hasCompletedOnboarding = true
            }
        }
    }
}

#Preview {
    StartView()
}
