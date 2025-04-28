import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var senderId: String
    var receiverId: String
    var content: String
    var timestamp: Date
    var isRead: Bool
    
    // For testing
    static let examples = [
        Message(
            id: "msg1",
            senderId: "user2",
            receiverId: "user1",
            content: "Hello! Is the product still available?",
            timestamp: Date().addingTimeInterval(-3600 * 24),
            isRead: true
        ),
        Message(
            id: "msg2",
            senderId: "user1",
            receiverId: "user2",
            content: "Yes, of course! You can pick it up today.",
            timestamp: Date().addingTimeInterval(-3600 * 23),
            isRead: true
        ),
        Message(
            id: "msg3",
            senderId: "user2",
            receiverId: "user1",
            content: "Great! What time would be convenient for you?",
            timestamp: Date().addingTimeInterval(-3600 * 22),
            isRead: false
        ),
        Message(
            id: "msg4",
            senderId: "user3",
            receiverId: "user1",
            content: "Hello, I am interested in the book. Is it in good condition?",
            timestamp: Date().addingTimeInterval(-3600 * 12),
            isRead: true
        ),
        Message(
            id: "msg5",
            senderId: "user1",
            receiverId: "user3",
            content: "Good afternoon! Yes, the book is like new, all the pages are intact.",
            timestamp: Date().addingTimeInterval(-3600 * 11),
            isRead: false
        )
    ]
}
