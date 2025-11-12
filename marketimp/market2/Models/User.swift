import Foundation

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var email: String
    var profileImageURL: String?
    var rating: Double
    var createdAt: Date
    

    static let example = User(
        id: "user1",
        username: "Alex",
        email: "alex@example.com",
        profileImageURL: "https://www.google.com/url?sa=i&url=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fprofile&psig=AOvVaw21z5B96zkPeCYuRQKZtqQN&ust=1751283083774000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCMi8xZzElo4DFQAAAAAdAAAAABAE",
        rating: 4.8,
        createdAt: Date()
    )
}
