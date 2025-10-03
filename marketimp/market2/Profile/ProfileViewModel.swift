import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var userProducts: [Product] = []

    init(user: User = User.example) {
        self.user = user
        // Мы больше не вызываем loadUserProducts() здесь,
        // так как данные будут браться из DataManager.
    }

    // --- ИЗМЕНЕНИЕ: Эта функция больше не нужна ---
    // Мы ее удаляем, так как ProfileView теперь сам фильтрует
    // товары из общего списка в DataManager.
    /*
    private func loadUserProducts() {
        // self.userProducts = Product.examples.filter { $0.sellerId == user.id } // СТАРАЯ ОШИБКА
    }
    */

    func signOut() {
        // Здесь будет логика выхода из аккаунта
        print("User signed out")
    }
}
