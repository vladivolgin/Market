import SwiftUI
import FirebaseCore

@main
struct market2App: App {
    @StateObject private var dataManager = DataManager()
    @StateObject private var sessionStore = SessionStore()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
                .environmentObject(sessionStore)
        }
    }
}
