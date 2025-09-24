import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteConfirmation = false
    
    // Получаем версию и билд приложения
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
        return "Version \(version) (Build \(build))"
    }
    
    // URL для шаринга (нужно будет заменить на реальный)
    private var appShareURL: URL {
        URL(string: "https://apps.apple.com/app/idYOUR_APP_ID")! // TODO: Replace with your actual App ID
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                Form {
                    Section(header: Text("General").foregroundColor(.textSecondary)) {
                        // Кнопка "Оценить приложение"
                        Button(action: {
                            // Открывает нативный попап для оценки (на реальном устройстве)
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        }) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.accent)
                                Text("Rate App")
                            }
                        }
                        
                        // Кнопка "Поделиться"
                        ShareLink(item: appShareURL, subject: Text("Check out Roobeet Wishlist!"), message: Text("I'm using Roobeet Wishlist to organize my gift ideas. You should try it!")) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.accent)
                                Text("Share App")
                            }
                        }
                    }
                    .listRowBackground(Color.cardBackground)
                    .foregroundColor(.textPrimary)
                    
                    Section(header: Text("Danger Zone").foregroundColor(.textSecondary)) {
                        Button(role: .destructive, action: {
                            showDeleteConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                Text("Delete All Data")
                            }
                        }
                    }
                    .listRowBackground(Color.cardBackground)
                    
                    // Секция с версией приложения
                    Section {
                        
                    } footer: {
                        HStack {
                            Spacer()
                            Text(appVersion)
                                .foregroundColor(.textSecondary)
                                .font(.caption)
                            Spacer()
                        }
                        .padding(.top, 20)
                    }
                    .listRowBackground(Color.appBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .accentColor(.accent)
                }
            }
            .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    RealmManager.shared.deleteAllData()
                    // Можно добавить закрытие окна после удаления
                    // dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action is irreversible and will permanently delete all your wishlists, events, and achievements.")
            }
        }
    }
}
