import XCTest
@testable import market2

class ChatTests: XCTestCase {
    
    // Test chat initialization
    func testChatInitialization() {
        // Arrange
        let id = "test-chat-id"
        let participants = ["user1", "user2"]
        let lastMessage = Message(
            id: "msg-id",
            senderId: "user1",
            receiverId: "user2",
            content: "Hello!",
            timestamp: Date(),
            isRead: false
        )
        
        // Act
        let chat = Chat(
            id: id,
            participants: participants,
            lastMessage: lastMessage
        )
        
        // Assert
        XCTAssertEqual(chat.id, id)
        XCTAssertEqual(chat.participants, participants)
        XCTAssertEqual(chat.lastMessage?.id, lastMessage.id)
        XCTAssertEqual(chat.lastMessage?.content, lastMessage.content)
    }
    
    // Test chat initialization without last message
    func testChatInitializationWithoutLastMessage() {
        // Arrange
        let id = "test-chat-id"
        let participants = ["user1", "user2"]
        
        // Act
        let chat = Chat(
            id: id,
            participants: participants,
            lastMessage: nil
        )
        
        // Assert
        XCTAssertEqual(chat.id, id)
        XCTAssertEqual(chat.participants, participants)
        XCTAssertNil(chat.lastMessage)
    }
    
    // Test getting chats for a user
    func testGetChatsForUser() {
        // Act
        let user1Chats = Chat.getChatsForUser(userId: "user1")
        
        // Assert
        // User1 should have 2 chats: with user2 and with user3
        XCTAssertEqual(user1Chats.count, 2)
        
        // Check the first chat (should be with user3, as the last message is more recent)
        XCTAssertTrue(user1Chats[0].participants.contains("user1"))
        XCTAssertTrue(user1Chats[0].participants.contains("user3"))
        XCTAssertEqual(user1Chats[0].lastMessage?.id, "msg5")
        
        // Check the second chat (should be with user2)
        XCTAssertTrue(user1Chats[1].participants.contains("user1"))
        XCTAssertTrue(user1Chats[1].participants.contains("user2"))
        XCTAssertEqual(user1Chats[1].lastMessage?.id, "msg3")
    }
    
    // Test getting chats for another user
    func testGetChatsForUser2() {
        // Act
        let user2Chats = Chat.getChatsForUser(userId: "user2")
        
        // Assert
        // User2 should have 1 chat: with user1
        XCTAssertEqual(user2Chats.count, 1)
        
        // Check the chat
        XCTAssertTrue(user2Chats[0].participants.contains("user1"))
        XCTAssertTrue(user2Chats[0].participants.contains("user2"))
        XCTAssertEqual(user2Chats[0].lastMessage?.id, "msg3")
    }
    
    // Test getting chats for a user without chats
    func testGetChatsForUserWithNoChats() {
        // Act
        let user4Chats = Chat.getChatsForUser(userId: "user4")
        
        // Assert
        // User4 should not have any chats
        XCTAssertEqual(user4Chats.count, 0)
    }
    
    // Test sorting chats by last message timestamp
    func testChatsSortedByLastMessageTimestamp() {
        // Arrange
        let now = Date()
        
        let message1 = Message(
            id: "msg1",
            senderId: "user1",
            receiverId: "user2",
            content: "Hello",
            timestamp: now.addingTimeInterval(-3600), // 1 hour ago
            isRead: true
        )
        
        let message2 = Message(
            id: "msg2",
            senderId: "user1",
            receiverId: "user3",
            content: "Hi",
            timestamp: now, // now
            isRead: false
        )
        
        let message3 = Message(
            id: "msg3",
            senderId: "user1",
            receiverId: "user4",
            content: "Hey",
            timestamp: now.addingTimeInterval(-7200), // 2 hours ago
            isRead: true
        )
        
        let chat1 = Chat(id: "chat1", participants: ["user1", "user2"], lastMessage: message1)
        let chat2 = Chat(id: "chat2", participants: ["user1", "user3"], lastMessage: message2)
        let chat3 = Chat(id: "chat3", participants: ["user1", "user4"], lastMessage: message3)
        let chat4 = Chat(id: "chat4", participants: ["user1", "user5"], lastMessage: nil)
        
        // Act
        let chats = [chat1, chat2, chat3, chat4]
        let sortedChats = chats.sorted {
            ($0.lastMessage?.timestamp ?? Date.distantPast) > ($1.lastMessage?.timestamp ?? Date.distantPast)
        }
        
        // Assert
        XCTAssertEqual(sortedChats.count, 4)
        XCTAssertEqual(sortedChats[0].id, "chat2") // Most recent message
        XCTAssertEqual(sortedChats[1].id, "chat1") // 1 hour ago
        XCTAssertEqual(sortedChats[2].id, "chat3") // 2 hours ago
        XCTAssertEqual(sortedChats[3].id, "chat4") // No messages
    }
    
    // Test creating chat ID from participants
    func testChatIdCreation() {
        // Arrange
        let user1 = "user1"
        let user2 = "user2"
        
        // Act - create chat ID by sorting user IDs
        let chatId1 = [user1, user2].sorted().joined(separator: "_")
        let chatId2 = [user2, user1].sorted().joined(separator: "_")
        
        // Assert - IDs should be the same regardless of participant order
        XCTAssertEqual(chatId1, "user1_user2")
        XCTAssertEqual(chatId2, "user1_user2")
        XCTAssertEqual(chatId1, chatId2)
    }
    
    // Test checking unread messages in a chat
    func testUnreadMessagesInChat() {
        // Arrange
        let messages = Message.examples
        
        // Act
        let user1Chats = Chat.getChatsForUser(userId: "user1")
        
        // Assert
        // Check that there's an unread message in the chat with user2
        let chatWithUser2 = user1Chats.first { chat in
            chat.participants.contains("user2")
        }
        XCTAssertNotNil(chatWithUser2)
        XCTAssertFalse(chatWithUser2!.lastMessage!.isRead)
        XCTAssertEqual(chatWithUser2!.lastMessage!.id, "msg3")
        
        // Check that there's an unread message in the chat with user3
        let chatWithUser3 = user1Chats.first { chat in
            chat.participants.contains("user3")
        }
        XCTAssertNotNil(chatWithUser3)
        XCTAssertFalse(chatWithUser3!.lastMessage!.isRead)
        XCTAssertEqual(chatWithUser3!.lastMessage!.id, "msg5")
    }
    
    // Test filtering chats with unread messages
    func testFilterChatsWithUnreadMessages() {
        // Arrange
        let user1Chats = Chat.getChatsForUser(userId: "user1")
        
        // Act - filter chats with unread messages
        let unreadChats = user1Chats.filter { chat in
            guard let lastMessage = chat.lastMessage else {
                return false
            }
            return !lastMessage.isRead
        }
        
        // Assert
        XCTAssertEqual(unreadChats.count, 2) // Both chats should have unread messages
    }
    
    // Test getting the other participant in a chat
    func testGetOtherParticipant() {
        // Arrange
        let user1Chats = Chat.getChatsForUser(userId: "user1")
        let chat = user1Chats[0] // Take the first chat
        
        // Act - get the ID of the other participant
        let currentUserId = "user1"
        let otherParticipantId = chat.participants.first { $0 != currentUserId }
        
        // Assert
        XCTAssertNotNil(otherParticipantId)
        XCTAssertNotEqual(otherParticipantId, currentUserId)
        // The first chat should be with user3 (since sorting is by last message time)
        XCTAssertEqual(otherParticipantId, "user3")
    }
}
