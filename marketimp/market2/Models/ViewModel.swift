import SwiftUI

class ViewModel: ObservableObject {
    @Published var user: User
    @Published var userProducts: [Product] = []
    
    init(user: User = User.example) {
        self.user = user
        // В реальном приложении здесь будет загрузка данных с сервера
        self.loadUserProducts()
    }
    
    private func loadUserProducts() {
        // Имитация загрузки товаров пользователя
        self.userProducts = Product.examples.filter { $0.sellerId == user.id }
    }
    
    func signOut() {
        // Здесь будет логика выхода из аккаунта
        print("Пользователь вышел из аккаунта")
    }
}

