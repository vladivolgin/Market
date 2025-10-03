import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    // --- ИЗМЕНЕНИЕ: username -> email ---
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showingError = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Secure Login").font(.largeTitle).fontWeight(.bold)
            
            // --- ИЗМЕНЕНИЕ: TextField для Email ---
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress) // Улучшение для ввода email
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Log In") {
                guard validateInput() else { return }
                // --- ИЗМЕНЕНИЕ: Вызов правильной функции ---
                authManager.login(email: email, password: password)
            }
            .padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
        }
        .padding()
        .alert(isPresented: $showingError) {
            Alert(title: Text("Login Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func validateInput() -> Bool {
        // --- ИЗМЕНЕНИЕ: Проверка email ---
        if email.isEmpty || password.isEmpty {
            errorMessage = "Email and password cannot be empty."
            showingError = true
            return false
        }
        
        // Просто для примера, реальная валидация email сложнее
        if !email.contains("@") {
            errorMessage = "Please enter a valid email address."
            showingError = true
            return false
        }
        
        return true
    }
}
