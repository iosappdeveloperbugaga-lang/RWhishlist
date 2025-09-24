import SwiftUI

struct CustomTabItemView: View {
    let systemName: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemName)
                    .font(.system(size: 22))
                
                Text(title)
                    .font(.system(size: 10))
            }
        }
        .foregroundColor(isActive ? .accent : .textSecondary)
        .frame(maxWidth: .infinity)
    }
}
