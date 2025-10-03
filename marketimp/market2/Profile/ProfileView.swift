import SwiftUI

struct ProfileView: View {
    // 1. Добавляем EnvironmentObject для AuthManager
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // User avatar and name (без изменений)
                    // ... ваш существующий код для аватара и имени ...
                    
                    // My items (без изменений)
                    VStack(alignment: .leading) {
                        Text("My Items")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Логика отображения товаров остается прежней
                        if let userId = dataManager.userProfile?.id {
                            let userProducts = dataManager.products.filter { $0.sellerId == userId }
                            if userProducts.isEmpty {
                                Text("You don't have any items yet")
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(userProducts) { product in
                                            ProductCardSmall(product: product)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        } else {
                            // Это сообщение теперь будет видно, если пользователь не вошел в систему
                            Text("Log in to see your items")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding(.vertical)
                    
                    // Settings (без изменений)
                    // ... ваш существующий код для настроек ...

                    // 2. Добавляем кнопку Log Out
                    // Она появится только если пользователь аутентифицирован
                    if authManager.isAuthenticated {
                        Button(action: {
                            authManager.logout()
                        }) {
                            Text("Log Out")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10) // Небольшой отступ сверху
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// Структура ProductCardSmall остается без изменений
struct ProductCardSmall: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 150, height: 150)
                .overlay(Image(systemName: "photo").foregroundColor(.gray))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.subheadline)
                    .lineLimit(1)
                
                Text("\(product.price, specifier: "%.2f") $")
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .frame(width: 150)
    }
}
