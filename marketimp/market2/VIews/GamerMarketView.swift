// GamerMarketView.swift
import SwiftUI

struct GamerMarketView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var showingProductDetails = false
    @State private var selectedProduct: Product?
    
    // 1. Добавляем состояние для отслеживания ошибки валидации
    @State private var isInputInvalid = false

    var body: some View {
        NavigationView {
            VStack {
                // Поисковая строка
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Поиск", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        // 2. Добавляем `.onChange` для немедленной проверки ввода
                        .onChange(of: searchText) { _, newValue in
                            // Проверяем, содержит ли новый текст запрещенные символы
                            if !InputValidator.isSafe(newValue) {
                                isInputInvalid = true
                            } else {
                                isInputInvalid = false
                                // Только если ввод безопасен, отправляем запрос на сервер
                                Task {
                                    await dataManager.fetchProducts(searchText: newValue)
                                }
                            }
                        }
                }
                .padding(.horizontal)
                
                // 3. Отображаем сообщение об ошибке, если ввод некорректен
                if isInputInvalid {
                    Text("Search query contains invalid characters.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                // Отображение товаров (без изменений)
                if dataManager.products.isEmpty {
                    VStack {
                        Spacer()
                        if searchText.isEmpty {
                            Text("Нет доступных товаров")
                        } else {
                            Text("Нет результатов по запросу \"\(searchText)\"")
                        }
                        Spacer()
                    }
                    .font(.headline)
                    .foregroundColor(.gray)
                } else {
                    ProductsGrid(products: dataManager.products) { product in
                        selectedProduct = product
                        showingProductDetails = true
                    }
                }
            }
            .navigationTitle("Маркет")
            .sheet(isPresented: $showingProductDetails) {
                if let product = selectedProduct {
                    // Убедитесь, что у вас есть ProductDetailView
                    ProductDetailView(product: product) // <--- ТЕПЕРЬ ОНА АКТИВНА
                        .environmentObject(dataManager) // Передаем dataManager дальше
                }
            }
        }
    }
}

// Остальные структуры (ProductsGrid, ProductCard) остаются без изменений.
// Убедитесь, что они есть в вашем файле.
struct ProductsGrid: View {
    let products: [Product]
    let onProductTap: (Product) -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(products) { product in
                    ProductCard(product: product) {
                        onProductTap(product)
                    }
                }
            }
            .padding(16)
        }
    }
}

struct ProductCard: View {
    let product: Product
    @EnvironmentObject var dataManager: DataManager
    var onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let urlString = product.imageURLs.first, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(height: 150).frame(maxWidth: .infinity)
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fit).frame(height: 150).frame(maxWidth: .infinity).clipped()
                    case .failure:
                        Image(systemName: "photo").foregroundColor(.gray).frame(height: 150).frame(maxWidth: .infinity)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 150).overlay(Image(systemName: "photo").foregroundColor(.gray))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(product.title).font(.headline).lineLimit(1).truncationMode(.tail)
                Text(String(format: "%.2f $", product.price)).font(.subheadline).fontWeight(.bold).foregroundColor(.primary)
                HStack {
                    if let seller = dataManager.getUser(id: product.sellerId) {
                        Image(systemName: "person.circle").font(.caption).foregroundColor(.gray)
                        Text(seller.username).font(.caption).foregroundColor(.gray).lineLimit(1)
                        Spacer()
                        Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption)
                        Text(String(format: "%.1f", seller.rating)).font(.caption).foregroundColor(.gray)
                    } else {
                        Text("Неизвестный продавец").font(.caption).foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .onTapGesture {
            onTap()
        }
    }
}
