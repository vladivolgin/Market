import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    @State private var currentImageIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Галерея изображений или заглушка, если изображений нет
                if product.imageURLs.isEmpty {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 300)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.largeTitle)
                        )
                } else {
                    // В реальном приложении здесь будет галерея изображений
                    TabView(selection: $currentImageIndex) {
                        ForEach(0..<product.imageURLs.count, id: \.self) { index in
                            // Заглушка для изображения
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                        .font(.largeTitle)
                                )
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 300)
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
                
                // Информация о товаре
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("\(product.price, specifier: "%.2f") ₽")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(product.category)
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                        
                        Text(product.condition)
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                        
                        Text(product.location)
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Divider()
                    
                    Text("Описание")
                        .font(.headline)
                    
                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Информация о продавце
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    Text("Продавец")
                        .font(.headline)
                    
                    if let seller = dataManager.getUser(id: product.sellerId) {
                        HStack {
                            if let profileImageURL = seller.profileImageURL {
                                // В реальном приложении здесь будет загрузка изображения по URL
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(seller.username)
                                    .font(.subheadline)
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                    
                                    Text("\(seller.rating, specifier: "%.1f")")
                                        .font(.caption)
                                }
                            }
                        }
                    } else {
                        Text("Информация о продавце недоступна")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                // Кнопка "Написать продавцу"
                Button(action: {
                    if let seller = dataManager.getUser(id: product.sellerId) {
                        // Создаем чат с продавцом
                        let _ = dataManager.createChat(with: seller)
                        // Здесь можно добавить навигацию к чату
                    }
                }) {
                    Text("Написать продавцу")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .foregroundColor(.primary)
        })
    }
}
