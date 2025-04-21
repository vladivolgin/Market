import SwiftUI
import Combine

class DataManager: ObservableObject {
    // Опубликованные свойства
    @Published var products: [Product] = []
    @Published var chats: [Chat] = []
    @Published var userProfile: User?
    
    init() {
        // Инициализация с тестовыми данными
        products = Product.examples
        
        // Устанавливаем тестового пользователя
        userProfile = User.example
        
        // Загружаем чаты для текущего пользователя
        if let userId = userProfile?.id {
            chats = Chat.getChatsForUser(userId: userId)
        }
    }
    
    // Методы для работы с данными
    func fetchProducts() {
        // В реальном приложении здесь будет загрузка данных из API или базы данных
        // Для тестирования используем примеры
        products = Product.examples
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
        // Здесь может быть код для сохранения товара в базу данных или отправки на сервер
    }
    
    func createChat(with otherUser: User) -> Chat? {
        guard let currentUser = userProfile else { return nil }
        
        // Создаем ID чата, сортируя ID пользователей и соединяя их
        let chatId = [currentUser.id, otherUser.id].sorted().joined(separator: "_")
        
        // Проверяем, существует ли уже чат с этим ID
        if let existingChat = chats.first(where: { $0.id == chatId }) {
            return existingChat
        }
        
        // Создаем новый чат
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
        
        // Создаем ID чата
        let chatId = [currentUser.id, receiverId].sorted().joined(separator: "_")
        
        // Создаем новое сообщение
        let newMessage = Message(
            id: UUID().uuidString,
            senderId: currentUser.id,
            receiverId: receiverId,
            content: content,
            timestamp: Date(),
            isRead: false
        )
        
        // Находим индекс чата или создаем новый
        if let index = chats.firstIndex(where: { $0.id == chatId }) {
            // Обновляем последнее сообщение в чате
            chats[index].lastMessage = newMessage
        } else {
            // Создаем новый чат
            let newChat = Chat(
                id: chatId,
                participants: [currentUser.id, receiverId],
                lastMessage: newMessage
            )
            chats.append(newChat)
        }
        
        // Здесь должна быть логика для сохранения сообщения в базе данных или отправки на сервер
    }
    
    // Получение всех сообщений для конкретного чата
    func getMessages(for chatId: String) -> [Message] {
        // В реальном приложении здесь будет запрос к базе данных
        // Для тестирования используем примеры сообщений
        return Message.examples.filter { message in
            let participants = chatId.split(separator: "_").map(String.init)
            return (participants.contains(message.senderId) && participants.contains(message.receiverId))
        }.sorted { $0.timestamp < $1.timestamp }
    }
    
    // Получение пользователя по ID
    func getUser(id: String) -> User? {
        // В реальном приложении здесь будет запрос к базе данных
        // Для тестирования возвращаем пример пользователя
        if id == userProfile?.id {
            return userProfile
        }
        return User.example // В реальном приложении здесь будет поиск пользователя по ID
    }
    
    // Получение другого участника чата
    func getOtherParticipant(in chat: Chat) -> User? {
        guard let currentUserId = userProfile?.id else { return nil }
        
        // Находим ID другого участника
        if let otherUserId = chat.participants.first(where: { $0 != currentUserId }) {
            return getUser(id: otherUserId)
        }
        
        return nil
    }
    
    // Получение продавца для товара
    func getSeller(for product: Product) -> User? {
        // В реальном приложении здесь будет запрос к базе данных
        // Для тестирования используем пример пользователя
        return User.example
    }
}
