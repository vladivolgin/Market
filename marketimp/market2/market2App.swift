import SwiftUI

@main
struct market2App: App {
    // Creating an instance of DataManager as a StateObject
    @StateObject private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }
    }
}
