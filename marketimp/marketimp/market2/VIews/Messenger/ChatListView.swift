import SwiftUI

struct ChatsListView: View {
    @ObservedObject private var viewModel = MessengerViewModel.shared
    
    var body: some View {
    
        NavigationView {
            List(viewModel.chats) { chat in
                NavigationLink(destination: ChatView(chat: chat)) {
                    ChatRow(chat: chat)
                }
            }
            .navigationTitle("Messages")
          
            .onAppear {
                print(">>>> VIEW_APPEAR: ChatsListView появился на экране.")
            }
        }
    }
}


struct ChatRow: View {
    let chat: Chat
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            VStack(alignment: .leading) {
           
                Text(chat.otherParticipantId ?? "Собеседник")
                    .font(.headline)
                Text(chat.lastMessage ?? "Нет сообщений")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
            if let timestamp = chat.lastMessageTimestamp {
                Text(timestamp.dateValue(), style: .time)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}
