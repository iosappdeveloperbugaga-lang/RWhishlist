import Foundation

class CreateWishlistViewModel: ObservableObject {
    @Published var wishlistName = ""
    @Published var eventDate = Date()
    @Published var note = ""
    
    private let repository: WishlistRepositoryProtocol
    
    var isSaveButtonDisabled: Bool {
        wishlistName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(repository: WishlistRepositoryProtocol = WishlistRepository()) {
        self.repository = repository
    }
    
    func saveWishlist() {
        guard !isSaveButtonDisabled else { return }
        
        do {
            try repository.addWishlist(
                name: wishlistName,
                eventDate: eventDate,
                note: note.isEmpty ? nil : note
            )
        } catch {
            // Здесь можно обработать ошибку, например, показать alert
            print("Error saving wishlist: \(error.localizedDescription)")
        }
    }
}
