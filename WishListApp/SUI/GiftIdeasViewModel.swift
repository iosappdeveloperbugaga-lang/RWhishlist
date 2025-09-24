import Foundation
import Combine
import RealmSwift

// Определяем категории и опции сортировки для фильтра
enum GiftCategory: String, CaseIterable, Identifiable {
    case gadgets = "Gadgets"
    case creative = "Creative"
    case tech = "Tech"
    case home = "Home"
    case sport = "Sport"
    case books = "Books"
    case beauty = "Beauty"
    case kids = "Kids"
    
    var id: String { self.rawValue }
}

enum SortOption: String, CaseIterable, Identifiable {
    case nameAsc = "Name (A-Z)"
    case priceAsc = "Price (Low to High)"
    case priceDesc = "Price (High to Low)"
    
    var id: String { self.rawValue }
}


@MainActor
class GiftIdeasViewModel: ObservableObject {
    // Исходные данные
    private var allIdeas: [GiftIdeaObject] = []
    
    // Данные для отображения
    @Published var filteredIdeas: [GiftIdeaObject] = []
    @Published var wishlists: [WishlistObject] = []
    
    // Состояние для фильтра
    @Published var selectedCategories: Set<GiftCategory> = []
    @Published var priceRange: ClosedRange<Double> = 0...500
    @Published var sortOption: SortOption = .nameAsc
    @Published var maxPrice: Double = 500.0
    
    // Состояние для UI
    @Published var showWishlistSelector = false
    @Published var selectedGiftIdea: GiftIdeaObject?
    
    // Состояние для кастомного алерта
    @Published var showAddedToWishlistAlert = false
    @Published var lastAddedGiftName: String?
    
    private let giftIdeaRepository: GiftIdeaRepositoryProtocol
    private let wishlistRepository: WishlistRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(giftIdeaRepository: GiftIdeaRepositoryProtocol = GiftIdeaRepository(),
         wishlistRepository: WishlistRepositoryProtocol = WishlistRepository()) {
        self.giftIdeaRepository = giftIdeaRepository
        self.wishlistRepository = wishlistRepository
        
        setupBindings()
        fetchData()
    }
    
    private func setupBindings() {
        // Этот блок будет автоматически применять фильтры при изменении любого параметра
        Publishers.CombineLatest3($selectedCategories, $priceRange, $sortOption)
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main) // Небольшая задержка для плавности
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    private func fetchData() {
        // Загружаем идеи
        giftIdeaRepository.fetchIdeas()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] ideas in
                guard let self = self else { return }
                self.allIdeas = ideas
                // Устанавливаем максимальную цену для слайдера
                let maxPriceFromData = ideas.map(\.price).max() ?? 500.0
                self.maxPrice = maxPriceFromData
                self.priceRange = 0...maxPriceFromData
                // Применяем фильтры в первый раз
                self.applyFilters()
            })
            .store(in: &cancellables)
        
        // Загружаем вишлисты
        wishlistRepository.fetchWishlists()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] wishlists in
                self?.wishlists = wishlists
            })
            .store(in: &cancellables)
    }
    
    private func applyFilters() {
        var ideas = allIdeas
        
        // 1. Фильтрация по категориям
        if !selectedCategories.isEmpty {
            let categoryStrings = selectedCategories.map { $0.rawValue }
            ideas = ideas.filter { categoryStrings.contains($0.category) }
        }
        
        // 2. Фильтрация по цене
        ideas = ideas.filter { priceRange.contains($0.price) }
        
        // 3. Сортировка
        switch sortOption {
        case .nameAsc:
            ideas.sort { $0.title < $1.title }
        case .priceAsc:
            ideas.sort { $0.price < $1.price }
        case .priceDesc:
            ideas.sort { $0.price > $1.price }
        }
        
        self.filteredIdeas = ideas
    }
    
    func resetFilters() {
        selectedCategories.removeAll()
        priceRange = 0...maxPrice
        sortOption = .nameAsc
    }
    
    func selectGiftIdea(_ idea: GiftIdeaObject) {
        self.selectedGiftIdea = idea
        self.showWishlistSelector = true
    }
    
    func addSelectedGift(to wishlist: WishlistObject) {
        guard let giftIdea = selectedGiftIdea else { return }
        
        do {
            try wishlistRepository.addGiftToWishlist(wishlistId: wishlist.id, giftIdea: giftIdea)
            // Показываем кастомный алерт
            self.lastAddedGiftName = giftIdea.title
            self.showAddedToWishlistAlert = true
            
            // Автоматически скрываем алерт через 2 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showAddedToWishlistAlert = false
            }
            
        } catch {
            print("Error adding gift to wishlist: \(error)")
        }
        
        self.showWishlistSelector = false
        self.selectedGiftIdea = nil
    }
}
