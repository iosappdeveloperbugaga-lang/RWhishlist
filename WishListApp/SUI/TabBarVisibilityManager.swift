import SwiftUI

@MainActor
final class TabBarVisibilityManager: ObservableObject {
    @Published var isHidden: Bool = false
}
