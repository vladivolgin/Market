import SwiftUI
import FirebaseAuth

struct ChatDetailView: View {
    // Получаем ViewModel от родительского View, он управляет данными
    @ObservedObject var viewModel: MessengerViewModel
    
    // Получаем конкретный чат, который нужно отобразить
    let chat: Chat
    
    // ID текущего пользователя для определения, чье сообщение
    private var currentUserId: String? {
        // В реальном приложении здесь будет Auth.auth().currentUser?.uid
        // Для теста можно временно вписать "user1", если вы используете тестовые данные
        return Auth.auth().currentUser?.uid
    }

    var body: some View {
        VStack {
            // --- Список сообщений ---
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
                    // Автопрокрутка к последнему сообщению
                    .onChange(of: viewModel.messages.count) {
                        if let lastMessageId = viewModel.messages.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastMessageId, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            // --- Поле ввода ---
            HStack {
                TextField("Сообщение...", text: $viewModel.newMessageText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading)
                
                Button(action: {
                    // Отправляем сообщение через ViewModel
                    viewModel.sendMessage(to: chat.id ?? "")
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(viewModel.newMessageText.isEmpty ? .gray : .blue)
                }
                .padding(.trailing)
                .disabled(viewModel.newMessageText.isEmpty)
            }
            .padding(.bottom)
        }
        // В заголовке будет ID собеседника
        .navigationTitle(chat.otherParticipantId ?? "Чат")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Когда экран открывается, говорим ViewModel загрузить сообщения для этого чата
            viewModel.fetchMessages(for: chat.id ?? "")
        }
    }
}

