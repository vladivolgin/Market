import Foundation
import Firebase
import Combine
import FirebaseAuth
import FirebaseFirestore

class MessengerViewModel: ObservableObject {
    static let shared = MessengerViewModel()

    @Published var chats = [Chat]()
    @Published var messages = [Message]()
    @Published var newMessageText: String = ""
    @Published var validationError: String?

    private var db = Firestore.firestore()
    private var currentUserId: String? { Auth.auth().currentUser?.uid }
    

    private var messagesListener: ListenerRegistration?
    private var chatsListener: ListenerRegistration?

    private init() {
        fetchChats()
    }

    deinit {
   
        messagesListener?.remove()
        chatsListener?.remove()
    }

  
    func attachListener(for chatId: String) {
        guard !chatId.isEmpty else { return }
       
        guard messagesListener == nil else {
            print("Listener for chat \(chatId) is already attached.")
            return
        }

        let messagesQuery = db.collection("Chats").document(chatId).collection("Messages").order(by: "timestamp", descending: false)

        print("✅ Attaching listener for chat ID: \(chatId)")
        messagesListener = messagesQuery.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("❌ Error fetching messages: \(error?.localizedDescription ?? "unknown")")
                return
            }

            self?.messages = documents.compactMap { document -> Message? in
                try? document.data(as: Message.self)
            }
        }
    }


    func detachListener() {
        print("⚪️ Detaching listener.")
        messagesListener?.remove()
        messagesListener = nil

        messages = []
    }


    func fetchChats() {
        guard let userId = currentUserId else {
            print("❌ ДИАГНОСТИКА: fetchChats не может начаться, потому что currentUserId is nil.")
            return
        }
        print("✅ ДИАГНОСТИКА 1: Запускаем fetchChats для пользователя с ID: \(userId)")
        
        chatsListener?.remove()
        
        print("✅ ДИАГНОСТИКА 2: Создаем запрос .whereField(\"participantIds\", arrayContains: \"\(userId)\")")
        chatsListener = db.collection("Chats")
            .whereField("participantIds", arrayContains: userId)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                
                guard let documents = querySnapshot?.documents else {
                    print("❌ ДИАГНОСТИКА 3: Ответ от Firestore пустой. Ошибка: \(error?.localizedDescription ?? "неизвестная ошибка")")
                    return
                }
                
                print("✅ ДИАГНОСТИКА 3: Получен ответ от Firestore. Количество документов: \(documents.count)")
                
                if documents.isEmpty {
                    print("⚠️ ДИАГНОСТИКА: Запрос выполнен успешно, но не найдено ни одного чата для этого пользователя.")
                }
                
                self?.chats = documents.compactMap { queryDocumentSnapshot -> Chat? in
                    do {
                        let chat = try queryDocumentSnapshot.data(as: Chat.self)
                        print("  -> Успешно декодирован чат: \(chat.id ?? "no id")")
                        return chat
                    } catch {
                        print("  -> ❌ Ошибка декодирования документа \(queryDocumentSnapshot.documentID): \(error)")
                        return nil
                    }
                }
                print("✅ ДИАГНОСТИКА 4: Декодировано и присвоено \(self?.chats.count ?? 0) чатов.")
            }
    }

  
    func sendMessage(to chatId: String) {
        guard let userId = currentUserId, !chatId.isEmpty, !newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        let message = Message(
            senderId: userId,
            text: newMessageText,
            timestamp: Timestamp(date: Date())
        )

        let messagesCollection = db.collection("Chats").document(chatId).collection("Messages")
        
        do {
            try messagesCollection.addDocument(from: message)
            self.newMessageText = ""
            db.collection("Chats").document(chatId).updateData([
                "lastMessage": message.text,
                "lastMessageTimestamp": message.timestamp
            ])
        } catch {
            print("Ошибка при отправке сообщения: \(error)")
            validationError = "Не удалось отправить сообщение. Попробуйте снова."
        }
    }
}
