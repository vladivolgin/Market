import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    @State private var currentImageIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Placeholder because now no images are available
                if product.imageURLs.isEmpty {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 300)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.largeTitle)
                        )
                } else {
                    // In the future application, there will be a gallery of images here.
                    TabView(selection: $currentImageIndex) {
                        ForEach(0..<product.imageURLs.count, id: \.self) { index in
                            // Placeholder for an image
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                        .font(.largeTitle)
                                )
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 300)
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
                
                // Product info
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("\(product.price, specifier: "%.2f") ₽")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(product.category)
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                        
                        Text(product.condition)
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                        
                        Text(product.location)
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Divider()
                    
                    Text("Bio")
                        .font(.headline)
                    
                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Seller info
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    Text("Seller")
                        .font(.headline)
                    
                    if let seller = dataManager.getUser(id: product.sellerId) {
                        HStack {
                            if let profileImageURL = seller.profileImageURL {
                                // In the future application, an image will be loaded from a URL here.
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(seller.username)
                                    .font(.subheadline)
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                    
                                    Text("\(seller.rating, specifier: "%.1f")")
                                        .font(.caption)
                                }
                            }
                        }
                    } else {
                        Text("Seller info is unavailible")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                // “Write to seller” button
                Button(action: {
                    if let seller = dataManager.getUser(id: product.sellerId) {
                        // Creating a chat with a seller
                        let _ = dataManager.createChat(with: seller)
                        // Chat navigation
                    }
                }) {
                    Text("Contact the seller")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .foregroundColor(.primary)
        })
    }
}
