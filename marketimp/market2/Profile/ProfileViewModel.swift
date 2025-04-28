import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var userProducts: [Product] = []
    
    init(user: User = User.example) {
        self.user = user
        // In a future application, data will be downloaded from the server here.
        self.loadUserProducts()
    }
    
    private func loadUserProducts() {
        // Simulate loading of user's products
        self.userProducts = Product.examples.filter { $0.sellerId == user.id }
    }
    
    func signOut() {
        // This is where the logic for logging out of the account.
        print("User signed out")
    }
}
