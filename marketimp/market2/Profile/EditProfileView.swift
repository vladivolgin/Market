import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var user: User
    @State private var username: String
    @State private var email: String
    
    init(user: User) {
        self._user = State(initialValue: user)
        self._username = State(initialValue: user.username)
        self._email = State(initialValue: user.email)
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
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section {
                    Button("Save") {
                        // Update userdata
                        user.username = username
                        user.email = email
                        
                        // In a future application, data will be sent to the server here.
                        
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.blue)
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
}
