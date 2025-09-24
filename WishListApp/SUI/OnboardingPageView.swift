import SwiftUI

// Модель данных для страницы (без изменений)
struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}

// Массив данных для всех страниц (без изменений)
private let onboardingPages: [OnboardingPage] = [
    OnboardingPage(imageName: "gift.circle.fill",
                   title: "Welcome to Roobeet Wishlist!",
                   description: "Never forget a gift idea again. Plan, track, and celebrate every special occasion with ease."),
    OnboardingPage(imageName: "lightbulb.fill",
                   title: "Discover & Organize",
                   description: "Explore curated gift ideas and add them to personalized wishlists for birthdays, holidays, and more."),
    OnboardingPage(imageName: "calendar.badge.clock",
                   title: "Stay Ahead of Schedule",
                   description: "Use the scheduler to get timely reminders for important dates so you're always prepared."),
    OnboardingPage(imageName: "trophy.fill",
                   title: "Achieve Gifting Goals",
                   description: "Unlock achievements as you build your lists and become a gift-planning master. Let's get started!")
]

// View для одной страницы (без изменений)
struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.accent)
                .padding()
                .background(Color.cardBackground.opacity(0.5))
                .clipShape(Circle())
                .shadow(color: .accent.opacity(0.2), radius: 20)
            
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.largeTitle.bold())
                    .foregroundColor(.textPrimary)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.textSecondary)
            }
            .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

// --- ГЛАВНЫЙ КОНТЕЙНЕР ОНБОРДИНГА (ИЗМЕНЕНО) ---
struct OnboardingView: View {
    // Убираем @Binding, используем замыкание
    var onComplete: () -> Void
    
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack {
                // Pager с страницами
                TabView(selection: $selectedTab) {
                    ForEach(onboardingPages.indices, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .animation(.easeInOut, value: selectedTab)
                
                Spacer(minLength: 40)
                
                // Кнопка "Далее" / "Начать"
                PrimaryButton(
                    title: selectedTab == onboardingPages.count - 1 ? "Get Started" : "Next",
                    icon: selectedTab == onboardingPages.count - 1 ? "party.popper.fill" : "arrow.right"
                ) {
                    if selectedTab < onboardingPages.count - 1 {
                        // Переключаем на следующую страницу
                        withAnimation {
                            selectedTab += 1
                        }
                    } else {
                        // Вызываем замыкание, чтобы сообщить StartView о завершении
                        onComplete()
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}
