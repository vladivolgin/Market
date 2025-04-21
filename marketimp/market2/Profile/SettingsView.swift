import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var language = "Русский"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Основные")) {
                    Toggle("Уведомления", isOn: $notificationsEnabled)
                    Toggle("Темная тема", isOn: $darkModeEnabled)
                }
                
                Section(header: Text("Язык")) {
                    Picker("Язык приложения", selection: $language) {
                        Text("Русский").tag("Русский")
                        Text("English").tag("English")
                    }
                }
                
                Section(header: Text("Конфиденциальность")) {
                    NavigationLink(destination: Text("Политика конфиденциальности")) {
                        Text("Политика конфиденциальности")
                    }
                    
                    NavigationLink(destination: Text("Условия использования")) {
                        Text("Условия использования")
                    }
                }
                
                Section(header: Text("Данные")) {
                    Button("Очистить кэш") {
                        // Здесь будет логика очистки кэша
                    }
                    .foregroundColor(.blue)
                    
                    Button("Удалить аккаунт") {
                        // Здесь будет логика удаления аккаунта
                    }
                    .foregroundColor(.red)
                }
                
                Section {
                    Text("Версия приложения: 1.0.0")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
        }
    }
}
