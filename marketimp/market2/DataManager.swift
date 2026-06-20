
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
    @Published private(set) var userCache: [String: User] = [:]

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
            print("🔍 Downloading data for 'Forum Topic'...")
            
            let snapshot = try await db.collection("Forum Topic")
                .getDocuments()
            
            print("📄 Documents recieved: \(snapshot.documents.count)")
            
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

    // MARK: - Users (Работает с Firebase)

    // Returns nil on first call and fetches async; @Published userCache triggers a redraw once it resolves.
    func getUser(id: String) -> User? {
        if let cached = userCache[id] {
            return cached
        }
        Task { await fetchUser(id: id) }
        return nil
    }

    private func fetchUser(id: String) async {
        guard userCache[id] == nil else { return }
        do {
            let document = try await db.collection("Users").document(id).getDocument()
            guard var user = try? document.data(as: User.self) else { return }
            user.id = document.documentID
            userCache[id] = user
        } catch {
            print("❌ Error fetching user \(id): \(error.localizedDescription)")
        }
    }

    /// Finds (or creates) a direct chat between the current user and `otherUser`.
    func createChat(with otherUser: User) {
        guard let currentUserId = userProfile?.id, currentUserId != otherUser.id else { return }
        let participantIds = [currentUserId, otherUser.id].sorted()

        Task {
            do {
                let existing = try await db.collection("Chats")
                    .whereField("participantIds", isEqualTo: participantIds)
                    .getDocuments()
                guard existing.documents.isEmpty else { return }

                try await db.collection("Chats").addDocument(data: [
                    "participantIds": participantIds,
                    "lastMessage": NSNull()
                ])
            } catch {
                print("❌ Error creating chat with \(otherUser.id): \(error.localizedDescription)")
            }
        }
    }
}
