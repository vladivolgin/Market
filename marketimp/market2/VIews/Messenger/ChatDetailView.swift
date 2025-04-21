import SwiftUI

struct ChatDetailView: View {
    let chat: Chat
    @State private var messageText = ""
    @State private var messages: [Message] = []
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack {
            // Сообщения
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(messages) { message in
                        MessageBubble(
                            message: message,
                            isFromCurrentUser: message.senderId == dataManager.userProfile?.id
                        )
                    }
                }
                .padding()
            }
            
            // Поле ввода сообщения
            HStack {
                TextField("Сообщение", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle(getOtherUserName())
        .onAppear {
            // Загружаем сообщения для этого чата
            messages = dataManager.getMessages(for: chat.id)
        }
    }
    
    private func getOtherUserName() -> String {
        if let otherUser = dataManager.getOtherParticipant(in: chat) {
            return otherUser.username
        }
        return "Чат"
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let currentUserId = dataManager.userProfile?.id,
              let receiverId = chat.participants.first(where: { $0 != currentUserId }) else {
            return
        }
        
        // Отправляем сообщение
        dataManager.sendMessage(content: messageText, to: receiverId)
        
        // Создаем новое сообщение для отображения в интерфейсе
        let newMessage = Message(
            id: UUID().uuidString,
            senderId: currentUserId,
            receiverId: receiverId,
            content: messageText,
            timestamp: Date(),
            isRead: false
        )
        
        // Добавляем сообщение в список
        messages.append(newMessage)
        
        // Очищаем поле ввода
        messageText = ""
    }
}

