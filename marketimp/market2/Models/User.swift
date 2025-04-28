import Foundation

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var email: String
    var profileImageURL: String?
    var rating: Double
    var createdAt: Date
    
    // For testing
    static let example = User(
        id: "user1",
        username: "Alex",
        email: "alex@example.com",
        profileImageURL: "https://example.com/profile.jpg",
        rating: 4.8,
        createdAt: Date()
    )
}

