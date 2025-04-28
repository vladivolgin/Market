import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // User avatar and name
                    VStack {
                        if let user = dataManager.userProfile {
                            if let profileImageURL = user.profileImageURL {
                                // In a real app, this would load the image from URL
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .padding()
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                            
                            Text(user.username)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                
                                Text("\(user.rating, specifier: "%.1f")")
                                    .font(.headline)
                            }
                            
                            Text("On platform since \(formattedDate(user.createdAt))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("Guest")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Button(action: {
                                // Action for logging in
                            }) {
                                Text("Log In")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // My items
                    VStack(alignment: .leading) {
                        Text("My Items")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if let userId = dataManager.userProfile?.id {
                            let userProducts = dataManager.products.filter { $0.sellerId == userId }
                            
                            if userProducts.isEmpty {
                                Text("You don't have any items yet")
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(userProducts) { product in
                                            ProductCardSmall(product: product)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        } else {
                            Text("Log in to see your items")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding(.vertical)
                    
                    // Settings
                    VStack(alignment: .leading) {
                        Text("Settings")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            Button(action: {
                                // Action for editing profile
                            }) {
                                HStack {
                                    Image(systemName: "person")
                                    Text("Edit Profile")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .padding()
                                .background(Color.white)
                            }
                            
                            Divider()
                            
                            Button(action: {
                                // Action for privacy settings
                            }) {
                                HStack {
                                    Image(systemName: "lock")
                                    Text("Privacy Settings")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .padding()
                                .background(Color.white)
                            }
                            
                            Divider()
                            
                            Button(action: {
                                // Action for support
                            }) {
                                HStack {
                                    Image(systemName: "questionmark.circle")
                                    Text("Support")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .padding()
                                .background(Color.white)
                            }
                            
                            Divider()
                            
                            Button(action: {
                                // Action for logging out
                            }) {
                                HStack {
                                    Image(systemName: "arrow.right.square")
                                    Text("Log Out")
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                            }
                        }
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        }
    }
    
    // Date formatting
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// Small product card for display in profile
struct ProductCardSmall: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            // Product image
            if let imageURL = product.imageURLs.first {
                // In a real app, this would load the image from URL
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 150)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 150)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            
            // Product information
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.subheadline)
                    .lineLimit(1)
                
                Text("\(product.price, specifier: "%.2f") ₽")
                    .font(.caption)
                    .foregroundColor(.primary)
                
                // Product status
                Text(statusText(product.status))
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(statusColor(product.status).opacity(0.2))
                    .cornerRadius(4)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .frame(width: 150)
    }
    
    // Product status text
    private func statusText(_ status: ProductStatus) -> String {
        switch status {
        case .active:
            return "Active"
        case .sold:
            return "Sold"
        case .reserved:
            return "Reserved"
        }
    }
    
    // Product status color
    private func statusColor(_ status: ProductStatus) -> Color {
        switch status {
        case .active:
            return .green
        case .sold:
            return .red
        case .reserved:
            return .orange
        }
    }
}
