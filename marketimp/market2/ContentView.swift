import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddProduct = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Marketplace Tab
            MarketplaceView()
                .tabItem {
                    Label("Market", systemImage: "bag")
                }
                .tag(0)
            
            // Messages Tab
            ChatsListView()
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
                .tag(1)
            
            // Add Tab
            AddTabView(showingAddProduct: $showingAddProduct)
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }
                .tag(2)
            
            // Profile Tab
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView()
        }
    }
}

// Helper view for the "Add" tab
struct AddTabView: View {
    @Binding var showingAddProduct: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                Text("Add New Item")
                    .font(.headline)
                
                Button(action: {
                    showingAddProduct = true
                }) {
                    Text("Tap to Add")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .onTapGesture {
            showingAddProduct = true
        }
    }
}
