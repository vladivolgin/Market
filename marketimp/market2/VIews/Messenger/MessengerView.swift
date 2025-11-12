import SwiftUI

struct MessengerView: View {
    // Используем общий (shared) экземпляр ViewModel
    @ObservedObject private var viewModel = MessengerViewModel.shared

    var body: some View {
        NavigationView {
            if viewModel.chats.isEmpty {
                Text("No chats yet.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .navigationTitle("Messages")
            } else {
                List(viewModel.chats) { chat in
             
                    NavigationLink(destination: ChatView(chat: chat)) {
                        ChatRow(chat: chat)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Messages")
            }
        }
        .onAppear {
            
            viewModel.fetchChats()
        }
    }
}


struct MessengerView_Previews: PreviewProvider {
    static var previews: some View {
        MessengerView()
    }
}
