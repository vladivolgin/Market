import Foundation

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var email: String
    var profileImageURL: String?
    var rating: Double
    var createdAt: Date
    
    // Для тестирования
    static let example = User(
        id: "user1",
        username: "Алексей",
        email: "alex@example.com",
        profileImageURL: "https://example.com/profile.jpg",
        rating: 4.8,
        createdAt: Date()
    )
}

