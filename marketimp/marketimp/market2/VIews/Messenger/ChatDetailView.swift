import SwiftUI
import FirebaseAuth

struct ChatDetailView: View {

    @ObservedObject var viewModel: MessengerViewModel
    

    let chat: Chat
    

    private var currentUserId: String? {

        return Auth.auth().currentUser?.uid
    }

    var body: some View {
        VStack {

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
             
                    .onChange(of: viewModel.messages.count) {
                        if let lastMessageId = viewModel.messages.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastMessageId, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            

            HStack {
                TextField("Message", text: $viewModel.newMessageText)
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
            .padding(.bottom)
        }

        .navigationTitle(chat.otherParticipantId ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
    
            viewModel.attachListener(for: chat.id ?? "")
        }
    }
}

