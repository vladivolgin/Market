import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var userProducts: [Product] = []

    init(user: User = User.example) {
        self.user = user
        
    }


    func signOut() {
 
        print("User signed out")
    }
}
