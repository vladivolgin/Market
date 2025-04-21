import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddProduct = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Вкладка Маркет
            MarketplaceView()
                .tabItem {
                    Label("Маркет", systemImage: "bag")
                }
                .tag(0)
            
            // Вкладка Сообщения
            ChatsListView()
                .tabItem {
                    Label("Сообщения", systemImage: "message")
                }
                .tag(1)
            
            // Вкладка Добавить
            AddTabView(showingAddProduct: $showingAddProduct)
                .tabItem {
                    Label("Добавить", systemImage: "plus.circle.fill")
                }
                .tag(2)
            
            // Вкладка Профиль
            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person")
                }
                .tag(3)
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView()
        }
    }
}

// Вспомогательное представление для вкладки "Добавить"
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
                
                Text("Добавить новый товар")
                    .font(.headline)
                
                Button(action: {
                    showingAddProduct = true
                }) {
                    Text("Нажмите, чтобы добавить")
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
