import SwiftUI

struct MascotSticker: View {
    @Binding var animate: Bool
    
    // Начальное и конечное состояние для анимации
    private let initialScale: CGFloat = 1.0
    private let animatedScale: CGFloat = 1.2
    private let initialOffsetY: CGFloat = 0
    private let animatedOffsetY: CGFloat = -20
    
    var body: some View {
        // Заглушка, используем SF Symbol
        Image(systemName: "figure.australian.football")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .foregroundColor(.accent)
            .scaleEffect(animate ? animatedScale : initialScale)
            .offset(y: animate ? animatedOffsetY : initialOffsetY)
            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: animate)
            .onChange(of: animate) { newValue in
                if newValue {
                    // Через короткое время возвращаем анимацию в исходное состояние
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        animate = false
                    }
                }
            }
    }
}
