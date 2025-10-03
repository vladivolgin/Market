import SwiftUI
import FirebaseAuth

struct ChatView: View {
    @ObservedObject private var viewModel = MessengerViewModel.shared
    let chat: Chat
    private var currentUserId: String? { Auth.auth().currentUser?.uid }

    var body: some View {
        VStack {
            // MARK: - Messages List
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(
                                message: message,
                                isFromCurrentUser: message.senderId == currentUserId
                            )
                            .id(message.id)
                        }
                    }
                    .padding(.top)
                    // --- ИСПРАВЛЕННЫЙ БЛОК onChange ---
                    .onChange(of: viewModel.messages) {
                        // Auto-scroll to the last message
                        if let lastMessageId = viewModel.messages.last?.id {
                            withAnimation { proxy.scrollTo(lastMessageId, anchor: .bottom) }
                        }
                    }
                }
            }
            
            // MARK: - Message Input Field
            VStack(spacing: 4) {
                HStack {
                    TextField("Сообщение...", text: $viewModel.newMessageText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading)
                    
                    Button(action: {
                        viewModel.sendMessage(to: chat.id ?? "")
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(viewModel.newMessageText.isEmpty ? .gray : .blue)
                    }
                    .padding(.trailing)
                    .disabled(viewModel.newMessageText.isEmpty)
                }
                
                if let errorMessage = viewModel.validationError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .transition(.opacity.animation(.easeInOut))
                }
            }
            .padding(.bottom)
        }
        .navigationTitle(chat.otherParticipantId ?? "Чат")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.validationError = nil
            viewModel.fetchMessages(for: chat.id ?? "")
        }
    }
}

// Вспомогательные View (MessageBubble) остаются без изменений
struct MessageBubble: View {
    let message: Message
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser { Spacer(minLength: 50) }
            Text(message.text)
                .padding(12)
                .background(isFromCurrentUser ? .blue : Color(.systemGray5))
                .foregroundColor(isFromCurrentUser ? .white : .primary)
                .cornerRadius(16)
            if !isFromCurrentUser { Spacer(minLength: 50) }
        }
        .padding(.horizontal)
    }
}
