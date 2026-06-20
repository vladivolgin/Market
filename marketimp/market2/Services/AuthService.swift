import Foundation
import FirebaseAuth

/// Wraps Firebase Authentication so the rest of the app never imports FirebaseAuth directly.
protocol AuthServiceProtocol: AnyObject {
    /// Calls `handler` immediately with the current state, then again on every change.
    /// `uid` is `nil` when signed out.
    func observeAuthState(_ handler: @escaping (_ uid: String?) -> Void)
    func signIn(email: String, password: String) async throws
    func signOut() throws
}

final class FirebaseAuthService: AuthServiceProtocol {
    private var listenerHandle: AuthStateDidChangeListenerHandle?

    func observeAuthState(_ handler: @escaping (String?) -> Void) {
        listenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            handler(user?.uid)
        }
    }

    func signIn(email: String, password: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    deinit {
        if let listenerHandle {
            Auth.auth().removeStateDidChangeListener(listenerHandle)
        }
    }
}
