import SwiftUI

struct WishlistsView: View {
    @StateObject private var viewModel = WishlistsViewModel()
    @Binding var isTabBarVisible: Bool // Принимаем binding
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if viewModel.wishlists.isEmpty {
                    EmptyStateView(
                        imageName: "archivebox",
                        title: "Create your first wishlist",
                        description: "Start planning amazing gifts for your loved ones. Add events, set reminders, and never miss a special moment!",
                        buttonTitle: "Create Wishlist"
                    ) {
                        viewModel.showingCreateSheet = true
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.wishlists) { wishlist in
                                // Передаем binding дальше
                                NavigationLink(destination: WishlistDetailView(wishlist: wishlist, isTabBarVisible: $isTabBarVisible)) {
                                    WishlistRowView(wishlist: wishlist)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("My Wishlists")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showingCreateSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.accent)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingCreateSheet) {
                CreateWishlistView()
            }
        }
        .accentColor(.accent)
    }
}
