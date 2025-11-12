import XCTest
@testable import market2

class MessageTests: XCTestCase {
    
    // Test message initialization
    func testMessageInitialization() {
        // Arrange
        let id = "test-id"
        let senderId = "sender-id"
        let receiverId = "receiver-id"
        let content = "Hello, is the item still available?"
        let timestamp = Date()
        let isRead = false
        
        // Act
        let message = Message(
            id: id,
            senderId: senderId,
            receiverId: receiverId,
            content: content,
            timestamp: timestamp,
            isRead: isRead
        )
        
        // Assert
        XCTAssertEqual(message.id, id)
        XCTAssertEqual(message.senderId, senderId)
        XCTAssertEqual(message.receiverId, receiverId)
        XCTAssertEqual(message.content, content)
        XCTAssertEqual(message.timestamp, timestamp)
        XCTAssertEqual(message.isRead, isRead)
    }
    
    // Test read status change
    func testMessageReadStatusChange() {
        // Arrange
        var message = Message(
            id: "test-id",
            senderId: "sender-id",
            receiverId: "receiver-id",
            content: "Test message",
            timestamp: Date(),
            isRead: false
        )
        
        // Act & Assert - check initial status
        XCTAssertFalse(message.isRead)
        
        // Act - change status to "read"
        message.isRead = true
        
        // Assert - check that status has changed
        XCTAssertTrue(message.isRead)
    }
    
    // Test message examples
    func testMessageExamples() {
        // Act
        let examples = Message.examples
        
        // Assert
        XCTAssertEqual(examples.count, 5)
        
        // Check the first message
        XCTAssertEqual(examples[0].id, "msg1")
        XCTAssertEqual(examples[0].senderId, "user2")
        XCTAssertEqual(examples[0].receiverId, "user1")
        XCTAssertEqual(examples[0].content, "Hello! Is the item still available?")
        XCTAssertTrue(examples[0].isRead)
        
        // Check the third message (unread)
        XCTAssertEqual(examples[2].id, "msg3")
        XCTAssertEqual(examples[2].content, "Great! What time works for you?")
        XCTAssertFalse(examples[2].isRead)
        
        // Check the fifth message
        XCTAssertEqual(examples[4].id, "msg5")
        XCTAssertEqual(examples[4].senderId, "user1")
        XCTAssertEqual(examples[4].receiverId, "user3")
        XCTAssertFalse(examples[4].isRead)
    }
    
    // Test encoding and decoding (Codable)
    func testMessageCodable() {
        // Arrange
        let originalMessage = Message(
            id: "test-id",
            senderId: "sender-id",
            receiverId: "receiver-id",
            content: "Test message content",
            timestamp: Date(),
            isRead: false
        )
        
        // Act - encode message to JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try encoder.encode(originalMessage)
            
            // Decode JSON back to message
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedMessage = try decoder.decode(Message.self, from: jsonData)
            
            // Assert - check that the message after encoding/decoding is identical to the original
            XCTAssertEqual(decodedMessage.id, originalMessage.id)
            XCTAssertEqual(decodedMessage.senderId, originalMessage.senderId)
            XCTAssertEqual(decodedMessage.receiverId, originalMessage.receiverId)
            XCTAssertEqual(decodedMessage.content, originalMessage.content)
            XCTAssertEqual(decodedMessage.isRead, originalMessage.isRead)
            
            // For date, we only check year, month, day and hour, as seconds and milliseconds may differ
            let calendar = Calendar.current
            XCTAssertEqual(
                calendar.dateComponents([.year, .month, .day, .hour], from: decodedMessage.timestamp),
                calendar.dateComponents([.year, .month, .day, .hour], from: originalMessage.timestamp)
            )
            
        } catch {
            XCTFail("Failed to encode/decode Message: \(error)")
        }
    }
    
    // Test filtering messages by sender
    func testFilterMessagesBySender() {
        // Arrange
        let messages = Message.examples
        
        // Act - filter by sender "user1"
        let user1Messages = messages.filter { $0.senderId == "user1" }
        
        // Assert
        XCTAssertEqual(user1Messages.count, 2)
        XCTAssertEqual(user1Messages[0].id, "msg2")
        XCTAssertEqual(user1Messages[1].id, "msg5")
        
        // Act - filter by sender "user2"
        let user2Messages = messages.filter { $0.senderId == "user2" }
        
        // Assert
        XCTAssertEqual(user2Messages.count, 2)
        XCTAssertEqual(user2Messages[0].id, "msg1")
        XCTAssertEqual(user2Messages[1].id, "msg3")
    }
    
    // Test filtering messages by receiver
    func testFilterMessagesByReceiver() {
        // Arrange
        let messages = Message.examples
        
        // Act - filter by receiver "user1"
        let user1Messages = messages.filter { $0.receiverId == "user1" }
        
        // Assert
        XCTAssertEqual(user1Messages.count, 3)
        XCTAssertEqual(user1Messages[0].id, "msg1")
        XCTAssertEqual(user1Messages[1].id, "msg3")
        XCTAssertEqual(user1Messages[2].id, "msg4")
        
        // Act - filter by receiver "user3"
        let user3Messages = messages.filter { $0.receiverId == "user3" }
        
        // Assert
        XCTAssertEqual(user3Messages.count, 1)
        XCTAssertEqual(user3Messages[0].id, "msg5")
    }
    
    // Test filtering unread messages
    func testFilterUnreadMessages() {
        // Arrange
        let messages = Message.examples
        
        // Act - filter unread messages
        let unreadMessages = messages.filter { !$0.isRead }
        
        // Assert
        XCTAssertEqual(unreadMessages.count, 2)
        XCTAssertEqual(unreadMessages[0].id, "msg3")
        XCTAssertEqual(unreadMessages[1].id, "msg5")
    }
    
    // Test sorting messages by timestamp (newest to oldest)
    func testSortMessagesByTimestampDescending() {
        // Arrange
        let messages = Message.examples
        
        // Act
        let sortedMessages = messages.sorted { $0.timestamp > $1.timestamp }
        
        // Assert
        XCTAssertEqual(sortedMessages.count, 5)
        // Check that messages are sorted from newest to oldest
        for i in 0..<sortedMessages.count-1 {
            XCTAssertGreaterThanOrEqual(sortedMessages[i].timestamp, sortedMessages[i+1].timestamp)
        }
    }
    
    // Test sorting messages by timestamp (oldest to newest)
    func testSortMessagesByTimestampAscending() {
        // Arrange
        let messages = Message.examples
        
        // Act
        let sortedMessages = messages.sorted { $0.timestamp < $1.timestamp }
        
        // Assert
        XCTAssertEqual(sortedMessages.count, 5)
        // Check that messages are sorted from oldest to newest
        for i in 0..<sortedMessages.count-1 {
            XCTAssertLessThanOrEqual(sortedMessages[i].timestamp, sortedMessages[i+1].timestamp)
        }
    }
    
    // Test grouping messages by conversation
    func testGroupMessagesByConversation() {
        // Arrange
        let messages = Message.examples
        
        // Act - create a dictionary where the key is the conversation identifier (pair of users)
        var conversations: [String: [Message]] = [:]
        
        for message in messages {
            // Create a unique key for the conversation by sorting user IDs
            let participants = [message.senderId, message.receiverId].sorted()
            let conversationKey = participants.joined(separator: "-")
            
            if conversations[conversationKey] == nil {
                conversations[conversationKey] = []
            }
            
            conversations[conversationKey]?.append(message)
        }
        
        // Assert
        // There should be 2 conversations: user1-user2 and user1-user3
        XCTAssertEqual(conversations.count, 2)
        
        // Check conversation between user1 and user2
        let user1User2Key = ["user1", "user2"].sorted().joined(separator: "-")
        XCTAssertNotNil(conversations[user1User2Key])
        XCTAssertEqual(conversations[user1User2Key]?.count, 3)
        
        // Check conversation between user1 and user3
        let user1User3Key = ["user1", "user3"].sorted().joined(separator: "-")
        XCTAssertNotNil(conversations[user1User3Key])
        XCTAssertEqual(conversations[user1User3Key]?.count, 2)
    }
}
