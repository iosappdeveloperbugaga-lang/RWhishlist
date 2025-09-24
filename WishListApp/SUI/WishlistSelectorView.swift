import SwiftUI
import RealmSwift

struct WishlistSelectorView: View {
    @ObservedResults(WishlistObject.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false)) var wishlists
    var onSelect: (WishlistObject) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                if wishlists.isEmpty {
                    EmptyStateView(
                        imageName: "list.bullet.clipboard",
                        title: "No Wishlists Found",
                        description: "You need to create a wishlist before you can add gift ideas to it."
                    )
                } else {
                    List {
                        ForEach(wishlists) { wishlist in
                            Button(action: {
                                onSelect(wishlist)
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(wishlist.name).foregroundColor(.textPrimary)
                                        Text("\(wishlist.gifts.count) gifts")
                                            .font(.caption)
                                            .foregroundColor(.textSecondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        .listRowBackground(Color.cardBackground)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Add to Wishlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .accentColor(.accent)
                }
            }
        }
    }
}
