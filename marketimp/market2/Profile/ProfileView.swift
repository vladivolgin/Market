import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Аватар и имя пользователя
                    VStack {
                        if let user = dataManager.userProfile {
                            if let profileImageURL = user.profileImageURL {
                                // В реальном приложении здесь будет загрузка изображения по URL
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .padding()
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                            
                            Text(user.username)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                
                                Text("\(user.rating, specifier: "%.1f")")
                                    .font(.headline)
                            }
                            
                            Text("На платформе с \(formattedDate(user.createdAt))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("Гость")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Button(action: {
                                // Действие для входа в аккаунт
                            }) {
                                Text("Войти")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Мои товары
                    VStack(alignment: .leading) {
                        Text("Мои товары")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if let userId = dataManager.userProfile?.id {
                            let userProducts = dataManager.products.filter { $0.sellerId == userId }
                            
                            if userProducts.isEmpty {
                                Text("У вас пока нет товаров")
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
                            Text("Войдите, чтобы увидеть свои товары")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding(.vertical)
                    
                    // Настройки
                    VStack(alignment: .leading) {
                        Text("Настройки")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            Button(action: {
                                // Действие для редактирования профиля
                            }) {
                                HStack {
                                    Image(systemName: "person")
                                    Text("Редактировать профиль")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .padding()
                                .background(Color.white)
                            }
                            
                            Divider()
                            
                            Button(action: {
                                // Действие для настроек приватности
                            }) {
                                HStack {
                                    Image(systemName: "lock")
                                    Text("Настройки приватности")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .padding()
                                .background(Color.white)
                            }
                            
                            Divider()
                            
                            Button(action: {
                                // Действие для поддержки
                            }) {
                                HStack {
                                    Image(systemName: "questionmark.circle")
                                    Text("Поддержка")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .padding()
                                .background(Color.white)
                            }
                            
                            Divider()
                            
                            Button(action: {
                                // Действие для выхода из аккаунта
                            }) {
                                HStack {
                                    Image(systemName: "arrow.right.square")
                                    Text("Выйти")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                            }
                        }
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Профиль")
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        }
    }
    
    // Форматирование даты
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// Маленькая карточка товара для отображения в профиле
struct ProductCardSmall: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            // Изображение товара
            if let imageURL = product.imageURLs.first {
                // В реальном приложении здесь будет загрузка изображения по URL
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 150)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 150)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            
            // Информация о товаре
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.subheadline)
                    .lineLimit(1)
                
                Text("\(product.price, specifier: "%.2f") ₽")
                    .font(.caption)
                    .foregroundColor(.primary)
                
                // Статус товара
                Text(statusText(product.status))
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(statusColor(product.status).opacity(0.2))
                    .cornerRadius(4)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .frame(width: 150)
    }
    
    // Текст статуса товара
    private func statusText(_ status: ProductStatus) -> String {
        switch status {
        case .active:
            return "Активен"
        case .sold:
            return "Продан"
        case .reserved:
            return "Зарезервирован"
        }
    }
    
    // Цвет статуса товара
    private func statusColor(_ status: ProductStatus) -> Color {
        switch status {
        case .active:
            return .green
        case .sold:
            return .red
        case .reserved:
            return .orange
        }
    }
}
