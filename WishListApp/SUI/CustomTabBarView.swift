import SwiftUI

struct CustomTabBarView: View {
    // Используем enum Tab из ContentView
    @Binding var selectedTab: ContentView.Tab
    
    var body: some View {
        HStack {
            CustomTabItemView(
                systemName: "list.bullet",
                title: "Wishlists",
                isActive: selectedTab == .wishlists
            ) {
                selectedTab = .wishlists
            }
            
            CustomTabItemView(
                systemName: "lightbulb",
                title: "Ideas",
                isActive: selectedTab == .ideas
            ) {
                selectedTab = .ideas
            }
            
            CustomTabItemView(
                systemName: "calendar",
                title: "Scheduler",
                isActive: selectedTab == .scheduler
            ) {
                selectedTab = .scheduler
            }
            
            CustomTabItemView(
                systemName: "trophy",
                title: "Progress",
                isActive: selectedTab == .progress
            ) {
                selectedTab = .progress
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 24) // Увеличиваем отступ снизу для safe area
        .background(Color.cardBackground)
    }
}
