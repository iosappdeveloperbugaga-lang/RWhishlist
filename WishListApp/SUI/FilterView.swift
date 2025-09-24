import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: GiftIdeasViewModel
    @Environment(\.dismiss) var dismiss
    
    // --- ИСПРАВЛЕНИЕ: СОЗДАЕМ КАСТОМНЫЕ BINDING'И ДЛЯ СЛАЙДЕРОВ ---
    private var minPriceBinding: Binding<Double> {
        Binding<Double>(
            get: { self.viewModel.priceRange.lowerBound },
            set: { newMin in
                // Убедимся, что минимальное значение не превышает максимальное
                let newUpperBound = max(newMin, self.viewModel.priceRange.upperBound)
                self.viewModel.priceRange = newMin...newUpperBound
            }
        )
    }
    
    private var maxPriceBinding: Binding<Double> {
        Binding<Double>(
            get: { self.viewModel.priceRange.upperBound },
            set: { newMax in
                // Убедимся, что максимальное значение не меньше минимального
                let newLowerBound = min(newMax, self.viewModel.priceRange.lowerBound)
                self.viewModel.priceRange = newLowerBound...newMax
            }
        )
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    Text("Filter & Sort")
                        .font(.title2.bold())
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding()
                .foregroundColor(.textPrimary)
                
                // Контент скроллится
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Секция Категории
                        VStack(alignment: .leading) {
                            Text("Categories").font(.headline).foregroundColor(.textPrimary)
                            let columns = [GridItem(.adaptive(minimum: 120))] // Делаем адаптивным
                            LazyVGrid(columns: columns, alignment: .leading) {
                                ForEach(GiftCategory.allCases) { category in
                                    Toggle(category.rawValue, isOn: Binding(
                                        get: { viewModel.selectedCategories.contains(category) },
                                        set: { isOn in
                                            if isOn {
                                                viewModel.selectedCategories.insert(category)
                                            } else {
                                                viewModel.selectedCategories.remove(category)
                                            }
                                        }
                                    ))
                                    .toggleStyle(.button)
                                    .tint(.accent)
                                }
                            }
                        }
                        
                        // --- СЕКЦИЯ ЦЕНЫ ПОЛНОСТЬЮ ПЕРЕПИСАНА ---
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Price Range").font(.headline).foregroundColor(.textPrimary)
                            
                            // Слайдер для минимальной цены
                            VStack(alignment: .leading) {
                                Text(String(format: "Min Price: $%.0f", viewModel.priceRange.lowerBound))
                                    .font(.subheadline)
                                    .foregroundColor(.textSecondary)
                                Slider(value: minPriceBinding, in: 0...viewModel.maxPrice, step: 1)
                                    .tint(.accent)
                            }
                            
                            // Слайдер для максимальной цены
                            VStack(alignment: .leading) {
                                Text(String(format: "Max Price: $%.0f", viewModel.priceRange.upperBound))
                                    .font(.subheadline)
                                    .foregroundColor(.textSecondary)
                                Slider(value: maxPriceBinding, in: 0...viewModel.maxPrice, step: 1)
                                    .tint(.accent)
                            }
                        }
                        // --- КОНЕЦ ИСПРАВЛЕНИЙ ---
                        
                        // Секция Сортировки
                        VStack(alignment: .leading) {
                            Text("Sort By").font(.headline).foregroundColor(.textPrimary)
                            Picker("Sort By", selection: $viewModel.sortOption) {
                                ForEach(SortOption.allCases) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                    }
                    .padding()
                }
                
                // Нижние кнопки
                HStack {
                    Button("Reset") {
                        viewModel.resetFilters()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.cardBackground)
                    .foregroundColor(.textPrimary)
                    .cornerRadius(16)
                    
                    PrimaryButton(title: "Apply", icon: "checkmark") {
                        dismiss()
                    }
                }
                .padding()
            }
        }
    }
}
