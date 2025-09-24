import SwiftUI
import RealmSwift

struct AddEventView: View {
    @State private var eventName: String = ""
    @State private var eventDate: Date = Date()
    @State private var selectedWishlistId: ObjectId?
    
    @ObservedResults(WishlistObject.self, sortDescriptor: SortDescriptor(keyPath: "name")) var wishlists
    
    @Environment(\.dismiss) var dismiss
    
    private var isSaveButtonDisabled: Bool {
        eventName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private let repository = EventRepository()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                Form {
                    Section(header: Text("Event Details").foregroundColor(.textSecondary)) {
                        TextField("Event Name", text: $eventName)
                        DatePicker("Date", selection: $eventDate, displayedComponents: .date)
                    }
                    .listRowBackground(Color.cardBackground)
                    
                    Section(header: Text("Link to Wishlist (Optional)").foregroundColor(.textSecondary)) {
                        Picker("Select a wishlist", selection: $selectedWishlistId) {
                            Text("None").tag(ObjectId?.none)
                            ForEach(wishlists) { wishlist in
                                Text(wishlist.name).tag(ObjectId?.some(wishlist.id))
                            }
                        }
                    }
                    .listRowBackground(Color.cardBackground)
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(.textPrimary)
                .tint(.accent)
            }
            .navigationTitle("Add Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEvent()
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(isSaveButtonDisabled)
                }
            }
            .accentColor(.accent)
        }
    }
    
    private func saveEvent() {
        do {
            try repository.addEvent(
                title: eventName,
                date: eventDate,
                linkedWishlistId: selectedWishlistId
            )
        } catch {
            print("Failed to save event: \(error)")
        }
    }
}
