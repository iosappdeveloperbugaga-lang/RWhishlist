import SwiftUI
import PhotosUI

struct AddGiftView: View {
    @State private var title: String = ""
    @State private var priceString: String = ""
    
    // Новые состояния для фото
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    var onSave: (String, Double?, Data?) -> Void // Обновленная сигнатура
    @Environment(\.dismiss) var dismiss
    
    private var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // --- НОВЫЙ БЛОК ДЛЯ PHOTOS PICKER ---
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            ZStack {
                                if let selectedPhotoData, let uiImage = UIImage(data: selectedPhotoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .frame(height: 200)
                                    
                                    VStack(spacing: 8) {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.largeTitle)
                                        Text("Add Photo (Optional)")
                                    }
                                    .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        .onChange(of: selectedPhotoItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedPhotoData = data
                                }
                            }
                        }
                        // --- КОНЕЦ НОВОГО БЛОКА ---
                        
                        StyledTextField(
                            placeholder: "Gift title",
                            text: $title,
                            iconName: "gift"
                        )
                        
                        StyledTextField(
                            placeholder: "Price (optional)",
                            text: $priceString,
                            iconName: "dollarsign.circle"
                        )
                        .keyboardType(.decimalPad)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Add New Gift")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let price = Double(priceString.replacingOccurrences(of: ",", with: "."))
                        onSave(title, price, selectedPhotoData) // Передаем данные фото
                    }
                    .disabled(isSaveDisabled)
                    .fontWeight(.bold)
                }
            }
            .accentColor(.accent)
        }
    }
}
