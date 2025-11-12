import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var language = "English"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                }
                
                Section(header: Text("Language")) {
                    Picker("App Language", selection: $language) {
                        Text("English").tag("English")
                        Text("Russian").tag("Russian")
                    }
                }
                
                Section(header: Text("Privacy")) {
                    NavigationLink(destination: Text("Privacy Policy")) {
                        Text("Privacy Policy")
                    }
                    
                    NavigationLink(destination: Text("Terms of Use")) {
                        Text("Terms of Use")
                    }
                }
                
                Section(header: Text("Data")) {
                    Button("Clear Cache") {
                        // Cache clearing logic will be here
                    }
                    .foregroundColor(.blue)
                    
                    Button("Delete Account") {
                        // Account deletion logic will be here
                    }
                    .foregroundColor(.red)
                }
                
                Section {
                    Text("App Version: 1.0.0")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
