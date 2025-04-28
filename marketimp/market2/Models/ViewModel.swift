import SwiftUI

class ViewModel: ObservableObject {
    @Published var user: User
    @Published var userProducts: [Product] = []
    
    init(user: User = User.example) {
        self.user = user
        // In a future application, data will be downloaded from the server here.
        self.loadUserProducts()
    }
    
    private func loadUserProducts() {
        // Simulation of user product downloads
        self.userProducts = Product.examples.filter { $0.sellerId == user.id }
    }
    
    func signOut() {
        // Here is the logic for logging out of account.
        print("User signed out.")
    }
}

