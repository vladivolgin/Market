import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: MessengerViewModel
    let chat: Chat
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { scrollView in
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message, isFromCurrentUser: message.senderId == viewModel.currentUserId)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .onChange(of: viewModel.messages.count) { oldCount, newCount in
                        if let lastMessage = viewModel.messages.last {
                            withAnimation {
                                scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    .onAppear {
                        if let lastMessage = viewModel.messages.last {
                            scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Поле ввода сообщения
            HStack {
                TextField("Сообщение", text: $viewModel.newMessageText)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding(10)
                }
                .disabled(viewModel.newMessageText.isEmpty)
            }
            .padding()
        }
        .navigationTitle(viewModel.getOtherUserName(chat))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadMessages(for: chat)
        }
    }
}

struct MessageBubble: View {
    let message: Message
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
            }
            
            Text(message.content)
                .padding(12)
                .background(isFromCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isFromCurrentUser ? .white : .primary)
                .cornerRadius(16)
                .frame(maxWidth: 280, alignment: isFromCurrentUser ? .trailing : .leading)
            
            if !isFromCurrentUser {
                Spacer()
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MessengerViewModel()
        let chat = Chat.getChatsForUser(userId: "user1").first!
        
        return ChatView(viewModel: viewModel, chat: chat)
    }
}
