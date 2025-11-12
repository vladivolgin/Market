
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
            
            await fetchProducts(searchText: "")
        }
    }
    
    // MARK: - Products (Работает с Firebase)
    
    func fetchProducts(searchText: String) async {
  
        guard InputValidator.isSafe(searchText) else {
            print("❌ Aborted fetching products: Search text contains invalid characters.")
           
            return
        }
      

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
    
    // MARK: - News (Placeholder)
    
    func fetchNews() async {
       
    }
    
    // MARK: - Forum (Placeholder)
    
    func fetchForumTopics() async {
        do {
            print("🔍 Загружаем из 'Forum Topic'...")
            
            let snapshot = try await db.collection("Forum Topic") // С пробелом!
                .getDocuments()
            
            print("📄 Получено документов: \(snapshot.documents.count)")
            
            if let firstDoc = snapshot.documents.first {
                print("📋 Первый документ: \(firstDoc.data())")
            }
            
            self.forumTopics = snapshot.documents.compactMap { document in
                try? document.data(as: ForumTopic.self)
            }
            
            print("✅ Successfully fetched \(forumTopics.count) forum topics.")
            
        } catch {
            print("❌ Error fetching forum topics: \(error.localizedDescription)")
            self.forumTopics = []
        }
    }
    
    // MARK: Other functions (Placeholder)
    
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
        
    }
    
    func createChat(with otherUser: User) -> Chat? {
        return nil
    }
}
