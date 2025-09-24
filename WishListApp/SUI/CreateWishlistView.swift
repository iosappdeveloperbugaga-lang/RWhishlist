import SwiftUI

struct CreateWishlistView: View {
    @StateObject private var viewModel = CreateWishlistViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Vishlist Name")
                            .foregroundColor(.textSecondary)
                            .font(.caption.bold())
                        
                        StyledTextField(
                            placeholder: "e.g. Birthday Gifts, Christmas 2025",
                            text: $viewModel.wishlistName,
                            iconName: "gift"
                        )
                        
                        Text("Event Date")
                            .foregroundColor(.textSecondary)
                            .font(.caption.bold())
                        
                        DatePicker(
                            "Select Date",
                            selection: $viewModel.eventDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(12)
                        .colorScheme(.dark) // Важно для правильного отображения DatePicker
                        
                        Text("Note (Optional)")
                            .foregroundColor(.textSecondary)
                            .font(.caption.bold())
                        
                        TextEditor(text: $viewModel.note)
                            .frame(height: 100)
                            .padding(10)
                            .background(Color.cardBackground)
                            .cornerRadius(12)
                            .tint(.accent)
                            .foregroundColor(.textPrimary)
                            .scrollContentBackground(.hidden)

                        Spacer()
                    }
                    .padding()
                }
                
            }
            .navigationTitle("Create Wishlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveWishlist()
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(viewModel.isSaveButtonDisabled)
                }
            }
            .accentColor(.accent)
        }
    }
}
