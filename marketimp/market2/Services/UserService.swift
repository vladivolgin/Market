import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// Wraps Firestore access to the "Users" collection so the rest of the app never imports FirebaseFirestore directly.
protocol UserServiceProtocol: AnyObject {
    func fetchUser(id: String) async throws -> User
    func updateUser(_ user: User) async throws
}

final class FirestoreUserService: UserServiceProtocol {
    private let db = Firestore.firestore()

    func fetchUser(id: String) async throws -> User {
        let document = try await db.collection("Users").document(id).getDocument()
        var user = try document.data(as: User.self)
        user.id = document.documentID
        return user
    }

    func updateUser(_ user: User) async throws {
        try db.collection("Users").document(user.id).setData(from: user, merge: true)
    }
}
