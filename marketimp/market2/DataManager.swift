import SwiftUI
import Combine

class DataManager: ObservableObject {
    // Published properties
    @Published var products: [Product] = []
    @Published var chats: [Chat] = []
    @Published var userProfile: User?
    
    init() {
        // Initialization with test data
        products = Product.examples
        
        // Set test user
        userProfile = User.example
        
        // Load chats for current user
        if let userId = userProfile?.id {
            chats = Chat.getChatsForUser(userId: userId)
        }
    }
    
    // Methods for working with data
    func fetchProducts() {
        // In a future app, this would load data from an API or database
        // For testing, we use examples
        products = Product.examples
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
        // Here could be code for saving the product to a database or sending to a server
    }
    
    func createChat(with otherUser: User) -> Chat? {
        guard let currentUser = userProfile else { return nil }
        
        // Create chat ID by sorting user IDs and joining them
        let chatId = [currentUser.id, otherUser.id].sorted().joined(separator: "_")
        
        // Check if a chat with this ID already exists
        if let existingChat = chats.first(where: { $0.id == chatId }) {
            return existingChat
        }
        
        // Create a new chat
        let newChat = Chat(
            id: chatId,
            participants: [currentUser.id, otherUser.id],
            lastMessage: nil
        )
        
        chats.append(newChat)
        return newChat
    }
    
    func sendMessage(content: String, to receiverId: String) {
        guard let currentUser = userProfile else { return }
        
        // Create chat ID
        let chatId = [currentUser.id, receiverId].sorted().joined(separator: "_")
        
        // Create a new message
        let newMessage = Message(
            id: UUID().uuidString,
            senderId: currentUser.id,
            receiverId: receiverId,
            content: content,
            timestamp: Date(),
            isRead: false
        )
        
        // Find chat index or create a new one
        if let index = chats.firstIndex(where: { $0.id == chatId }) {
            // Update the last message in the chat
            chats[index].lastMessage = newMessage
        } else {
            // Create a new chat
            let newChat = Chat(
                id: chatId,
                participants: [currentUser.id, receiverId],
                lastMessage: newMessage
            )
            chats.append(newChat)
        }
        
        // Here should be logic for saving the message to a database or sending to a server
    }
    
    // Get all messages for a specific chat
    func getMessages(for chatId: String) -> [Message] {
        // In a future app, this would be a database query
        // For testing, we use example messages
        return Message.examples.filter { message in
            let participants = chatId.split(separator: "_").map(String.init)
            return (participants.contains(message.senderId) && participants.contains(message.receiverId))
        }.sorted { $0.timestamp < $1.timestamp }
    }
    
    // Get user by ID
    func getUser(id: String) -> User? {
        // In a future app, this would be a database query
        // For testing, we return an example user
        if id == userProfile?.id {
            return userProfile
        }
        return User.example // In a real app, this would search for a user by ID
    }
    
    // Get the other participant in a chat
    func getOtherParticipant(in chat: Chat) -> User? {
        guard let currentUserId = userProfile?.id else { return nil }
        
        // Find the ID of the other participant
        if let otherUserId = chat.participants.first(where: { $0 != currentUserId }) {
            return getUser(id: otherUserId)
        }
        
        return nil
    }
    
    // Get seller for a product
    func getSeller(for product: Product) -> User? {
        // In a future app, this would be a database query
        // For testing, we use an example user
        return User.example
    }
}
