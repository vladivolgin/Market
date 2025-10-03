import SwiftUI

struct MessengerView: View {
    // Используем общий (shared) экземпляр ViewModel
    @ObservedObject private var viewModel = MessengerViewModel.shared

    var body: some View {
        NavigationView {
            if viewModel.chats.isEmpty {
                Text("У вас пока нет чатов")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .navigationTitle("Сообщения")
            } else {
                List(viewModel.chats) { chat in
                    // --- ИСПРАВЛЕНИЕ: Убираем лишний аргумент 'viewModel' ---
                    NavigationLink(destination: ChatView(chat: chat)) {
                        ChatRow(chat: chat)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Сообщения")
            }
        }
        .onAppear {
            // Мы можем вызывать fetchChats здесь, так как ViewModel теперь один
            // и это не вызовет бесконечного цикла.
            viewModel.fetchChats()
        }
    }
}

// Вспомогательное View для отображения одной строки в списке чатов
// (Остается без изменений)
struct MessengerView_Previews: PreviewProvider {
    static var previews: some View {
        MessengerView()
    }
}
