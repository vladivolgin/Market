import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    @State private var currentImageIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - Image Gallery
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
                    TabView(selection: $currentImageIndex) {
                        ForEach(0..<product.imageURLs.count, id: \.self) { index in
                            if let url = URL(string: product.imageURLs[index]) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(height: 300)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                    case .failure:
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .overlay(Image(systemName: "exclamationmark.triangle").foregroundColor(.gray).font(.largeTitle))
                                    @unknown default:
                                        Rectangle().fill(Color.gray.opacity(0.3))
                                    }
                                }
                                .tag(index)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .overlay(Image(systemName: "questionmark").foregroundColor(.gray).font(.largeTitle))
                                    .tag(index)
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 300)
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                }
                
                // MARK: - Product Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("\(product.price, specifier: "%.2f") $")
                        .font(.title2)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(product.category)
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
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
                
                // MARK: - Seller Info
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    Text("Seller")
                        .font(.headline)
                    
                    if let seller = dataManager.getUser(id: product.sellerId) {
                        HStack {
                            if let profileImageURLString = seller.profileImageURL, let profileImageURL = URL(string: profileImageURLString) {
                                AsyncImage(url: profileImageURL) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView().frame(width: 50, height: 50)
                                    case .success(let image):
                                        image.resizable().aspectRatio(contentMode: .fill).frame(width: 50, height: 50).clipShape(Circle())
                                    case .failure:
                                        Image(systemName: "person.circle.fill").resizable().frame(width: 50, height: 50).foregroundColor(.gray)
                                    @unknown default:
                                        Image(systemName: "person.circle.fill").resizable().frame(width: 50, height: 50).foregroundColor(.gray)
                                    }
                                }
                            } else {
                                Image(systemName: "person.circle.fill").resizable().frame(width: 50, height: 50).foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(seller.username).font(.subheadline)
                                HStack {
                                    Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption)
                                    Text("\(seller.rating, specifier: "%.1f")").font(.caption)
                                }
                            }
                        }
                    } else {
                        Text("Seller info is unavailible").foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                // --- CORRECTED AUTHORIZATION BLOCK ---
                if dataManager.userProfile?.id == product.sellerId {
                    VStack {
                        Divider().padding(.horizontal)
                        HStack(spacing: 16) {
                            Button(action: {
                                // TODO: Implement navigation to the editing screen
                                print("Edit button tapped for product \(product.id ?? "N/A")")
                            }) {
                                Text("Edit")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }

                            Button(action: {
                                // TODO: Implement deletion logic with confirmation
                                // IMPORTANT: Final authorization check must be in DataManager before deletion
                                // dataManager.delete(product)
                                print("Delete button tapped for product \(product.id ?? "N/A")")
                                presentationMode.wrappedValue.dismiss() // Dismiss view after deletion
                            }) {
                                Text("Delete")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                        }
                        .padding([.horizontal, .top])
                    }
                }
                
                // MARK: - Contact Seller Button
                // Показываем кнопку "Связаться", только если это не товар текущего пользователя
                if dataManager.userProfile?.id != product.sellerId {
                    Button(action: {
                        if let seller = dataManager.getUser(id: product.sellerId) {
                            let _ = dataManager.createChat(with: seller)
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
