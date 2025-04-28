import Foundation

struct Chat: Identifiable {
    var id: String
    var participants: [String]
    var lastMessage: Message?
    
    // For testing
    static func getChatsForUser(userId: String) -> [Chat] {
        let messages = Message.examples
        
        // Groups messages by chat participants
        var chatDictionary: [String: [Message]] = [:]
        
        for message in messages {
            if message.senderId == userId || message.receiverId == userId {
                let otherUserId = message.senderId == userId ? message.receiverId : message.senderId
                let chatId = [userId, otherUserId].sorted().joined(separator: "_")
                
                if chatDictionary[chatId] == nil {
                    chatDictionary[chatId] = []
                }
                
                chatDictionary[chatId]?.append(message)
            }
        }
        
        // Creates chats from grouped messages
        var chats: [Chat] = []
        
        for (chatId, chatMessages) in chatDictionary {
            let sortedMessages = chatMessages.sorted { $0.timestamp > $1.timestamp }
            let participants = chatId.split(separator: "_").map(String.init)
            
            let chat = Chat(
                id: chatId,
                participants: participants,
                lastMessage: sortedMessages.first
            )
            
            chats.append(chat)
        }
        
        // Sorts chats by time of last messages
        return chats.sorted {
            ($0.lastMessage?.timestamp ?? Date.distantPast) > ($1.lastMessage?.timestamp ?? Date.distantPast)
        }
    }
}
