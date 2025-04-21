import SwiftUI

@main
struct market2App: App {
    // Создаем экземпляр DataManager как StateObject
    @StateObject private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }
    }
}
