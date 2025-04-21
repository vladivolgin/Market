import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var senderId: String
    var receiverId: String
    var content: String
    var timestamp: Date
    var isRead: Bool
    
    // Для тестирования
    static let examples = [
        Message(
            id: "msg1",
            senderId: "user2",
            receiverId: "user1",
            content: "Привет! Товар еще доступен?",
            timestamp: Date().addingTimeInterval(-3600 * 24),
            isRead: true
        ),
        Message(
            id: "msg2",
            senderId: "user1",
            receiverId: "user2",
            content: "Да, конечно! Вы можете его забрать сегодня.",
            timestamp: Date().addingTimeInterval(-3600 * 23),
            isRead: true
        ),
        Message(
            id: "msg3",
            senderId: "user2",
            receiverId: "user1",
            content: "Отлично! Во сколько вам удобно?",
            timestamp: Date().addingTimeInterval(-3600 * 22),
            isRead: false
        ),
        Message(
            id: "msg4",
            senderId: "user3",
            receiverId: "user1",
            content: "Здравствуйте, интересует книга. Она в хорошем состоянии?",
            timestamp: Date().addingTimeInterval(-3600 * 12),
            isRead: true
        ),
        Message(
            id: "msg5",
            senderId: "user1",
            receiverId: "user3",
            content: "Добрый день! Да, книга как новая, страницы все целые.",
            timestamp: Date().addingTimeInterval(-3600 * 11),
            isRead: false
        )
    ]
}
