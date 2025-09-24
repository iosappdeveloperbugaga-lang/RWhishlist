import Foundation
import Combine
import RealmSwift

class WishlistsViewModel: ObservableObject {
    @Published var wishlists: [WishlistObject] = []
    @Published var showingCreateSheet = false
    
    private let repository: WishlistRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: WishlistRepositoryProtocol = WishlistRepository()) {
        self.repository = repository
        fetchWishlists()
    }
    
    func fetchWishlists() {
        repository.fetchWishlists()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching wishlists: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] wishlists in
                self?.wishlists = wishlists
            })
            .store(in: &cancellables)
    }
    
    func deleteWishlist(at offsets: IndexSet) {
        offsets.forEach { index in
            let wishlist = wishlists[index]
            do {
                try repository.deleteWishlist(id: wishlist.id)
            } catch {
                print("Failed to delete wishlist: \(error.localizedDescription)")
            }
        }
    }
}
