import SwiftUI

// MARK: - Root View (The Router)
struct ContentView: View {
    
    @StateObject private var authManager = AuthManager()

    @StateObject private var dataManager = DataManager()

    var body: some View {

        if authManager.isAuthenticated {
            MainTabView()
                .environmentObject(authManager)
                .environmentObject(dataManager)
        } else {
            LoginView()
                .environmentObject(authManager)
        }
    }
}

// MARK: - Main Application View (Your Original UI)
struct MainTabView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            
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
