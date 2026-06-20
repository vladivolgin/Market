import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var user: User
    @State private var username: String
    @State private var email: String
    let onSave: (User) -> Void

    init(user: User, onSave: @escaping (User) -> Void) {
        self._user = State(initialValue: user)
        self._username = State(initialValue: user.username)
        self._email = State(initialValue: user.email)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile pictures")) {
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 100, height: 100)
                            
                            Text(String(username.prefix(1)))
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.gray)
                            
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(width: 100, height: 100)
                        }
                        .overlay(
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                )
                                .offset(x: 5, y: 5),
                            alignment: .bottomTrailing
                        )
                        .onTapGesture {
                            // Here will be logic of picking an image
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
                
                Section(header: Text("Private data")) {
                    TextField("Username", text: $username)
                    if let usernameError {
                        Text(usernameError).font(.caption).foregroundColor(.red)
                    }

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    if let emailError {
                        Text(emailError).font(.caption).foregroundColor(.red)
                    }
                }

                Section {
                    Button("Save") {
                        user.username = username
                        user.email = email
                        onSave(user)
                        dismiss()
                    }
                    .disabled(!isFormValid)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(isFormValid ? .blue : .gray)
                }
            }
            .navigationTitle("Change profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Field validation

    private var usernameError: String? {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return "Username cannot be empty." }
        if !InputValidator.isSafe(trimmed) { return "Username contains invalid characters." }
        if trimmed.count < 3 { return "Username must be at least 3 characters." }
        if !InputValidator.isLengthValid(trimmed, maxLength: 30) { return "Username is too long." }
        return nil
    }

    private var emailError: String? {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return "Email cannot be empty." }
        if !InputValidator.isLengthValid(trimmed, maxLength: 100) { return "Email is too long." }
        if !InputValidator.isValidEmail(trimmed) { return "Please enter a valid email address." }
        return nil
    }

    private var isFormValid: Bool {
        usernameError == nil && emailError == nil
    }
}
