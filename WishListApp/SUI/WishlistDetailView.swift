import SwiftUI
import RealmSwift

struct WishlistDetailView: View {
    @StateObject var viewModel: WishlistDetailViewModel
    @Binding var isTabBarVisible: Bool // Принимаем binding
    
    init(wishlist: WishlistObject, isTabBarVisible: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: WishlistDetailViewModel(wishlist: wishlist))
        _isTabBarVisible = isTabBarVisible
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            if viewModel.wishlist.gifts.isEmpty {
                EmptyStateView(
                    imageName: "gift.circle",
                    title: "No Gifts Yet",
                    description: "Add your first gift idea to this wishlist.",
                    buttonTitle: "Add Gift"
                ) {
                    viewModel.showAddGiftSheet = true
                }
            } else {
                List {
                    ForEach(viewModel.wishlist.gifts) { gift in
                        GiftRowView(gift: gift) {
                            viewModel.togglePurchasedStatus(for: gift)
                        }
                    }
                    .onDelete(perform: viewModel.deleteGift)
                    .listRowBackground(Color.cardBackground)
                    .listRowSeparatorTint(Color.appBackground)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
            }
            
            if viewModel.isWishlistComplete {
                CelebrationView()
                    .transition(.opacity.animation(.easeIn(duration: 0.5)))
            }
        }
        .navigationTitle(viewModel.wishlist.name)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.showAddGiftSheet = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.accent)
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddGiftSheet) {
            AddGiftView { title, price, photoData in
                viewModel.addGift(title: title, price: price, photoData: photoData)
            }
        }
        // Управляем видимостью таб-бара при появлении/исчезновении этого View
        .onAppear {
            isTabBarVisible = false
        }
        .onDisappear {
            isTabBarVisible = true
        }
    }
}

// CelebrationView остается без изменений
struct CelebrationView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "party.popper.fill")
                    .resizable().scaledToFit().frame(height: 120).foregroundColor(.accent)
                Text("Wishlist Complete!").font(.largeTitle.bold()).foregroundColor(.textPrimary)
                Text("Congratulations! You've found all the gifts.").foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center).padding(.horizontal)
            }
            .padding(40).background(Color.cardBackground).cornerRadius(20)
            .shadow(color: .accent.opacity(0.3), radius: 20, x: 0, y: 0)
        }
    }
}
