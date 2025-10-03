import Foundation
import Firebase
import Combine
import FirebaseAuth
import FirebaseFirestore

class MessengerViewModel: ObservableObject {
    static let shared = MessengerViewModel()

    @Published var chats = [Chat]()
    @Published var messages = [Message]() // Массив для сообщений текущего чата
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

    // Функция для загрузки списка чатов (ваша версия с диагностикой)
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

    // --- НОВАЯ РЕАЛИЗАЦИЯ ---
    // Функция для загрузки сообщений конкретного чата
    func fetchMessages(for chatId: String) {
        guard !chatId.isEmpty else { return }

        // Удаляем предыдущий слушатель, чтобы не было утечек
        messagesListener?.remove()

        // Создаем путь к подколлекции Messages
        let messagesQuery = db.collection("Chats").document(chatId).collection("Messages").order(by: "timestamp", descending: false)

        messagesListener = messagesQuery.addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Ошибка при загрузке сообщений: \(error?.localizedDescription ?? "неизвестно")")
                return
            }

            // Декодируем документы в массив [Message]
            self?.messages = documents.compactMap { document -> Message? in
                try? document.data(as: Message.self)
            }
        }
    }

    // --- НОВАЯ РЕАЛИЗАЦИЯ ---
    // Функция для отправки нового сообщения
    func sendMessage(to chatId: String) {
        guard let userId = currentUserId, !chatId.isEmpty, !newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        // Создаем новый объект сообщения
        let message = Message(
            senderId: userId,
            text: newMessageText,
            timestamp: Timestamp(date: Date())
        )

        // Получаем ссылку на подколлекцию
        let messagesCollection = db.collection("Chats").document(chatId).collection("Messages")

        do {
            // Добавляем новый документ в Firestore
            try messagesCollection.addDocument(from: message)
            
            // Очищаем поле ввода после успешной отправки
            self.newMessageText = ""
            
            // Обновляем lastMessage в родительском документе чата
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
