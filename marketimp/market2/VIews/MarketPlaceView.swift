import SwiftUI

struct MarketplaceView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var showingProductDetails = false
    @State private var selectedProduct: Product?
    
    var body: some View {
        NavigationView {
            VStack {
                // Поисковая строка
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Поиск товаров", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Отображение товаров
                if dataManager.products.isEmpty {
                    // Если товаров нет, показываем сообщение
                    VStack {
                        Spacer()
                        Text("Нет доступных товаров")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                } else {
                    // Отображение товаров с использованием переиспользуемого компонента
                    ProductsGrid(products: filteredProducts) { product in
                        selectedProduct = product
                        showingProductDetails = true
                    }
                }
            }
            .navigationTitle("Маркет")
            .sheet(isPresented: $showingProductDetails) {
                if let product = selectedProduct {
                    ProductDetailView(product: product)
                }
            }
        }
        .onAppear {
            // Загрузка товаров при появлении экрана
            dataManager.fetchProducts()
        }
    }
    
    // Фильтрация товаров по поисковому запросу
    private var filteredProducts: [Product] {
        if searchText.isEmpty {
            return dataManager.products
        } else {
            return dataManager.products.filter { product in
                product.title.lowercased().contains(searchText.lowercased()) ||
                product.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

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
        VStack(alignment: .leading) {
            // Product image
            if let imageURL = product.imageURLs.first {
                // In the future application, an image will be loaded from a URL here.
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            
            // Product info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("\(product.price, specifier: "%.2f") ₽")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "person.circle")
                        .foregroundColor(.gray)
                    
                    // Getting seller info
                    if let seller = dataManager.getUser(id: product.sellerId) {
                        Text(seller.username)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                            
                            Text("\(seller.rating, specifier: "%.1f")")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Text("Uknown seller")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .onTapGesture {
            onTap()
        }
    }
}
