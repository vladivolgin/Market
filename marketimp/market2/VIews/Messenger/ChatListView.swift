import SwiftUI

struct ChatsListView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            List {
                if dataManager.chats.isEmpty {
                    Text("У вас пока нет сообщений")
                        .foregroundColor(.gray)
                } else {
                    ForEach(dataManager.chats) { chat in
                        NavigationLink(destination: ChatDetailView(chat: chat)) {
                            ChatRow(chat: chat)
                        }
                    }
                }
            }
            .navigationTitle("Сообщения")
            .onAppear {
                // Если у пользователя есть ID, загружаем его чаты
                if let userId = dataManager.userProfile?.id {
                    // В реальном приложении здесь будет загрузка чатов из базы данных
                    // Для тестирования используем примеры
                    dataManager.chats = Chat.getChatsForUser(userId: userId)
                }
            }
        }
    }
}

struct ChatRow: View {
    let chat: Chat
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        HStack {
            // Аватар другого участника
            if let otherUser = dataManager.getOtherParticipant(in: chat) {
                if let imageURL = otherUser.profileImageURL {
                    // В реальном приложении здесь будет загрузка изображения
                    // Для тестирования используем заглушку
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading) {
                    Text(otherUser.username)
                        .font(.headline)
                    
                    if let lastMessage = chat.lastMessage {
                        Text(lastMessage.content)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
            } else {
                // Если не удалось получить другого участника
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                
                Text("Неизвестный пользователь")
                    .font(.headline)
            }
        }
    }
}
