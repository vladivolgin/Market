import SwiftUI

class ViewModel: ObservableObject {
    @Published var user: User
    @Published var userProducts: [Product] = []

    init(user: User = User.example) {
        self.user = user
        // Теперь данные должны загружаться из вашего DataManager.
        // self.loadUserProducts()
    }

    // Этот метод использовал временные данные (Product.examples), которые больше недоступны.
    // Вам следует заменить это на метод, который фильтрует товары из вашего DataManager.
    /*
    private func loadUserProducts() {
        // Симуляция загрузки товаров пользователя
        self.userProducts = Product.examples.filter { $0.sellerId == user.id }
    }
    */

    func signOut() {
        // Здесь будет логика выхода из аккаунта.
        print("User signed out.")
    }
}
