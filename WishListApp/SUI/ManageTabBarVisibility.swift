import SwiftUI

struct ManageTabBarVisibility: ViewModifier {
    @EnvironmentObject private var tabBarManager: TabBarVisibilityManager
    let newIsHiddenState: Bool
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                // Устанавливаем нужное состояние при появлении View
                tabBarManager.isHidden = newIsHiddenState
            }
            .onDisappear {
                // Важно: при исчезновении View, которое скрывало таб-бар,
                // мы должны вернуть его в состояние по умолчанию (видимое).
                // Мы делаем это только если View действительно скрывало таб-бар.
                if newIsHiddenState == true {
                    tabBarManager.isHidden = false
                }
            }
    }
}

extension View {
    /// Управляет видимостью системного таб-бара.
    /// - Parameter isHidden: Установить `true`, чтобы скрыть таб-бар на этом экране.
    func manageTabBarVisibility(isHidden: Bool) -> some View {
        self.modifier(ManageTabBarVisibility(newIsHiddenState: isHidden))
    }
}
