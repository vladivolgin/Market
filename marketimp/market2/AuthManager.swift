import Foundation
import Combine
import FirebaseAuth // <-- ВАЖНО: Убедитесь, что у вас есть этот импорт

@MainActor
class AuthManager: ObservableObject {
    @Published var user: FirebaseAuth.User?
    @Published var isAuthenticated = false
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?

    init() {
        // Регистрируем обработчик, который будет следить за состоянием аутентификации
        registerAuthStateHandler()
    }

    deinit {
        // Отписываемся от обработчика при уничтожении объекта
        if let handle = authStateHandler {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    private func registerAuthStateHandler() {
        authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.user = user
            self?.isAuthenticated = (user != nil)
            
            // Обновляем userProfile в DataManager
            // Это свяжет AuthManager и DataManager
            // Вам нужно будет добавить этот метод в DataManager
            // DataManager.shared.updateUserProfile(with: user)
        }
    }

    func login(email: String, password: String) {
        // Используем стандартный метод входа Firebase
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
