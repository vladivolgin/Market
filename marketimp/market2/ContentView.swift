import SwiftUI

// MARK: - Root View (The Router)
struct ContentView: View {
    // Создаем AuthManager один раз как источник правды для всего приложения
    @StateObject private var authManager = AuthManager()
    // Убедитесь, что вы создаете DataManager здесь, если он нужен всем вашим вью
    @StateObject private var dataManager = DataManager()

    var body: some View {
        // В зависимости от состояния authManager, показываем либо вход, либо главный экран
        if authManager.isAuthenticated {
            MainTabView()
                .environmentObject(authManager) // Передаем его дальше по иерархии
                .environmentObject(dataManager)
        } else {
            LoginView()
                .environmentObject(authManager) // Передаем его на экран входа
        }
    }
}

// MARK: - Main Application View (Your Original UI)
// Эта структура просто собирает ваши существующие экраны в TabView.
// Она не объявляет их заново.
struct MainTabView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Здесь мы ИСПОЛЬЗУЕМ ваши существующие View, а не создаем их копии
            NewsView()
                .tabItem { Label("News", systemImage: "newspaper") }
                .tag(0)

            ForumView()
                .tabItem { Label("Forum", systemImage: "bubble.left.and.bubble.right") }
                .tag(1)

            GamerMarketView()
                .tabItem { Label("Market", systemImage: "gamecontroller") }
                .tag(2)
            
            ChatsListView()
                .tabItem { Label("Messages", systemImage: "message") }
                .tag(3)
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
                .tag(4)
        }
    }
}
