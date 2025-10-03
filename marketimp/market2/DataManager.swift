// DataManager.swift
import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class DataManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published var userProfile: User?
    @Published var products: [Product] = []
    @Published var chats: [Chat] = []
    @Published var newsArticles: [NewsArticle] = []
    @Published var forumTopics: [ForumTopic] = []

    private var db = Firestore.firestore()

    init() {
        loadUserProfile()
        Task {
            // При первом запуске загружаем все товары
            await fetchProducts(searchText: "")
        }
    }
    
    // MARK: - Products (Работает с Firebase)
    
    func fetchProducts(searchText: String) async {
        // --- ИЗМЕНЕНИЕ: Добавляем проверку безопасности ---
        // Если поисковый запрос содержит небезопасные символы,
        // мы прерываем выполнение функции и не отправляем запрос на сервер.
        guard InputValidator.isSafe(searchText) else {
            print("❌ Aborted fetching products: Search text contains invalid characters.")
            // Опционально: можно очистить `products`, если поисковый запрос плохой
            // self.products = []
            return
        }
        // --- КОНЕЦ ИЗМЕНЕНИЯ ---

        var query: Query = db.collection("Products")

        if !searchText.isEmpty {
            query = query.whereField("title", isGreaterThanOrEqualTo: searchText)
                         .whereField("title", isLessThan: searchText + "\u{f8ff}")
        }

        do {
            let snapshot = try await query.getDocuments()
            self.products = snapshot.documents.compactMap { document in
                try? document.data(as: Product.self)
            }
            print("✅ Successfully fetched \(products.count) products.")
        } catch {
            print("❌ Error fetching products: \(error.localizedDescription)")
            self.products = []
        }
    }
    
    // MARK: - News (Заглушка)
    
    func fetchNews() async {
        // ... ваш код без изменений ...
    }
    
    // MARK: - Forum (Заглушка)
    
    func fetchForumTopics() async {
        // ... ваш код без изменений ...
    }
    
    // MARK: - Остальные функции-заглушки
    
    func loadUserProfile() {
        userProfile = User.example
    }
    
    func addProduct(_ product: Product) {
        products.insert(product, at: 0)
    }
    
    func getUser(id: String) -> User? {
        return User.example
    }
    
    func getOtherParticipant(in chat: Chat) -> User? {
        return User.example
    }
    
    func getMessages(for chatId: String) -> [Message] {
        return []
    }
    
    func sendMessage(content: String, to chatId: String) {
        // Логика отправки сообщения будет здесь
    }
    
    func createChat(with otherUser: User) -> Chat? {
        return nil
    }
}
