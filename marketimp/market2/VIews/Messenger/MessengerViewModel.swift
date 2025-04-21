import SwiftUI

class MessengerViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var currentUserId: String = "user1" // В реальном приложении это будет ID авторизованного пользователя
    @Published var selectedChat: Chat?
    @Published var messages: [Message] = []
    @Published var newMessageText: String = ""
    
    init() {
        loadChats()
    }
    
    func loadChats() {
        // В реальном приложении здесь будет загрузка чатов с сервера
        chats = Chat.getChatsForUser(userId: currentUserId)
    }
    
    func loadMessages(for chat: Chat) {
        // В реальном приложении здесь будет загрузка сообщений с сервера
        selectedChat = chat
        
        messages = Message.examples.filter { message in
            (message.senderId == currentUserId && message.receiverId == getOtherUserId(chat)) ||
            (message.receiverId == currentUserId && message.senderId == getOtherUserId(chat))
        }.sorted { $0.timestamp < $1.timestamp }
    }
    
    func sendMessage() {
        guard !newMessageText.isEmpty, let chat = selectedChat else { return }
        
        let otherUserId = getOtherUserId(chat)
        
        let newMessage = Message(
            id: UUID().uuidString,
            senderId: currentUserId,
            receiverId: otherUserId,
            content: newMessageText,
            timestamp: Date(),
            isRead: false
        )
        
        // В реальном приложении здесь будет отправка сообщения на сервер
        messages.append(newMessage)
        
        // Обновляем последнее сообщение в чате
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index].lastMessage = newMessage
        }
        
        newMessageText = ""
    }
    
    func getOtherUserId(_ chat: Chat) -> String {
        return chat.participants.first { $0 != currentUserId } ?? ""
    }
    
    func getOtherUserName(_ chat: Chat) -> String {
        let otherUserId = getOtherUserId(chat)
        
        // В реальном приложении здесь будет получение имени пользователя из базы данных
        switch otherUserId {
        case "user2":
            return "Александр"
        case "user3":
            return "Елена"
        default:
            return "Пользователь"
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "dd.MM.yy"
        }
        
        return formatter.string(from: date)
    }
    
    func isUnreadMessage(in chat: Chat) -> Bool {
        guard let lastMessage = chat.lastMessage else { return false }
        return lastMessage.receiverId == currentUserId && !lastMessage.isRead
    }
}

