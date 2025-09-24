import SwiftUI

struct ContentView: View {
    // Enum для безопасного управления вкладками
    enum Tab {
        case wishlists, ideas, scheduler, progress
    }
    
    @State private var selectedTab: Tab = .wishlists
    @State private var isTabBarVisible = true // Наше главное состояние видимости
    
    // --- УДАЛЯЕМ init() ОТСЮДА ---
    
    var body: some View {
        ZStack {
            // Главный контент, который меняется в зависимости от выбранной вкладки
            VStack {
                switch selectedTab {
                case .wishlists:
                    // Передаем binding для управления видимостью
                    WishlistsView(isTabBarVisible: $isTabBarVisible)
                case .ideas:
                    // TODO: Добавить isTabBarVisible и для этих View, если у них будет навигация
                    GiftIdeasView()
                case .scheduler:
                    SchedulerView()
                case .progress:
                    AchievementsView()
                }
            }
            
            // Наш кастомный таб-бар, который появляется и исчезает
            if isTabBarVisible {
                VStack {
                    Spacer() // Толкает таб-бар вниз
                    CustomTabBarView(selectedTab: $selectedTab)
                }
                .transition(.move(edge: .bottom)) // Анимация появления/исчезновения
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isTabBarVisible)
        .ignoresSafeArea(.keyboard) // Чтобы клавиатура не толкала таб-бар вверх
    }
}
