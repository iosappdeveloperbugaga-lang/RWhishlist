import SwiftUI

struct GiftIdeasView: View {
    @StateObject private var viewModel = GiftIdeasViewModel()
    @State private var showFilterSheet = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                // Основной контент
                VStack(alignment: .leading, spacing: 0) {
                    // Новый подзаголовок
                    Text("New inspirations for every occasion")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.filteredIdeas) { idea in
                                GiftIdeaCardView(idea: idea) {
                                    viewModel.selectGiftIdea(idea)
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 150)
                    }
                }
                
                // Кастомный алерт поверх всего
                if viewModel.showAddedToWishlistAlert {
                    CustomAlertView(
                        systemImageName: "checkmark.circle.fill",
                        title: "Added!",
                        message: "\(viewModel.lastAddedGiftName ?? "Gift") added to wishlist."
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .navigationTitle("Gift Ideas")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showFilterSheet = true
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(.accent)
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showWishlistSelector) {
                WishlistSelectorView { selectedWishlist in
                    viewModel.addSelectedGift(to: selectedWishlist)
                }
            }
        }
        .accentColor(.accent)
    }
}
