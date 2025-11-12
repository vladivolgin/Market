import Foundation
import Combine
import FirebaseAuth 

@MainActor
class AuthManager: ObservableObject {
    @Published var user: FirebaseAuth.User?
    @Published var isAuthenticated = false
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?

    init() {

        registerAuthStateHandler()
    }

    deinit {
        
        if let handle = authStateHandler {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    private func registerAuthStateHandler() {
        authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.user = user
            self?.isAuthenticated = (user != nil)
            
           
        }
    }

    func login(email: String, password: String) {

        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("❌ Firebase login failed: \(error.localizedDescription)")
                return
            }
            
            print("✅ Firebase login successful!")
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            print("✅ Firebase logout successful!")
        } catch let signOutError as NSError {
            print("❌ Error signing out: %@", signOutError)
        }
    }
}
