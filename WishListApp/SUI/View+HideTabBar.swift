import SwiftUI

// Вспомогательная структура, которая будет выполнять UIKit-код
struct TabBarHiderView: UIViewControllerRepresentable {
    var isHidden: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        // Создаем "пустышку" UIViewController
        let viewController = UIViewController()
        // Сразу после создания ищем UITabBarController и применяем состояние
        DispatchQueue.main.async {
            viewController.setTabBarVisibility(isHidden)
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // При каждом обновлении SwiftUI View, применяем нужное состояние
        DispatchQueue.main.async {
            uiViewController.setTabBarVisibility(isHidden)
        }
    }
}

// Расширение для UIViewController, чтобы найти родительский TabBarController
extension UIViewController {
    func setTabBarVisibility(_ isHidden: Bool) {
        var parentVC = self.parent
        // Идем вверх по иерархии вью-контроллеров
        while let currentParent = parentVC {
            if let tabBarController = currentParent as? UITabBarController {
                // Найден! Управляем его таб-баром.
                tabBarController.tabBar.isHidden = isHidden
                return
            }
            parentVC = currentParent.parent
        }
    }
}

// Удобный модификатор для использования в SwiftUI
extension View {
    func hideTabBar(_ isHidden: Bool) -> some View {
        self.background(TabBarHiderView(isHidden: isHidden).frame(width: 0, height: 0))
    }
}
