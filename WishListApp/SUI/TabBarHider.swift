import SwiftUI

struct TabBarHider: ViewModifier {
    @EnvironmentObject var tabBarManager: TabBarVisibilityManager
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                tabBarManager.isHidden = false
            }
            .onDisappear {
                tabBarManager.isHidden = true
            }
    }
}

extension View {
    func hideTabBar() -> some View {
        self.modifier(TabBarHider())
    }
}
