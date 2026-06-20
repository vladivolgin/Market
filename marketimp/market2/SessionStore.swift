import Foundation

/// Holds the authentication/session state for the current user.
/// Delegates Firebase Auth/Firestore work to AuthService/UserService so this class stays UI- and Firebase-agnostic.
@MainActor
class SessionStore: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    private let authService: AuthServiceProtocol
    private let userService: UserServiceProtocol

    init(authService: AuthServiceProtocol = FirebaseAuthService(),
         userService: UserServiceProtocol = FirestoreUserService()) {
        self.authService = authService
        self.userService = userService
        authService.observeAuthState { [weak self] uid in
            Task { @MainActor in
                self?.handleAuthState(uid: uid)
            }
        }
    }

    private func handleAuthState(uid: String?) {
        isAuthenticated = uid != nil
        guard let uid else {
            currentUser = nil
            return
        }
        Task { await loadProfile(uid: uid) }
    }

    private func loadProfile(uid: String) async {
        do {
            currentUser = try await userService.fetchUser(id: uid)
        } catch {
            print("❌ Error loading profile for \(uid): \(error.localizedDescription)")
        }
    }

    func login(email: String, password: String) async {
        errorMessage = nil
        do {
            try await authService.signIn(email: email, password: password)
            print("✅ Firebase login successful!")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Firebase login failed: \(error.localizedDescription)")
        }
    }

    func logout() {
        do {
            try authService.signOut()
            print("✅ Firebase logout successful!")
        } catch {
            print("❌ Error signing out: \(error.localizedDescription)")
        }
    }

    func updateProfile(username: String, email: String) async {
        guard var user = currentUser else { return }
        user.username = username
        user.email = email
        do {
            try await userService.updateUser(user)
            currentUser = user
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error updating profile: \(error.localizedDescription)")
        }
    }
}
