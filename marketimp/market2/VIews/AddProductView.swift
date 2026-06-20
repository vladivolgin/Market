import SwiftUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var sessionStore: SessionStore

    @State private var title = ""
    @State private var description = ""
    @State private var price = ""
    @State private var category = "Electronics"
    @State private var condition = "Excellent"
    @State private var location = ""
    @State private var images: [UIImage] = []
    @State private var showingImagePicker = false
    
    let categories = ["Electronics", "Clothing & Shoes", "Books", "Sports & Leisure", "Furniture", "Other"]
    let conditions = ["New", "Excellent", "Good", "Fair"]
    
    var body: some View {
        NavigationView {
            Form {
                // Section with main information
                Section(header: Text("Product Information")) {
                    TextField("Title", text: $title)
                    if let titleError {
                        Text(titleError).font(.caption).foregroundColor(.red)
                    }

                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    if let priceError {
                        Text(priceError).font(.caption).foregroundColor(.red)
                    }

                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }

                    Picker("Condition", selection: $condition) {
                        ForEach(conditions, id: \.self) {
                            Text($0)
                        }
                    }

                    TextField("Location", text: $location)
                    if let locationError {
                        Text(locationError).font(.caption).foregroundColor(.red)
                    }

                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                        if let descriptionError {
                            Text(descriptionError).font(.caption).foregroundColor(.red)
                        }
                    }
                }
                
                // Section with photos
                Section(header: Text("Photos")) {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Add Photos")
                        }
                    }
                    
                    // Display selected images
                    if !images.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<images.count, id: \.self) { index in
                                    Image(uiImage: images[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            Button(action: {
                                                images.remove(at: index)
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.white)
                                                    .background(Color.black.opacity(0.7))
                                                    .clipShape(Circle())
                                            }
                                            .padding(5),
                                            alignment: .topTrailing
                                        )
                                }
                            }
                        }
                        .frame(height: 120)
                    }
                }
                
                // Add product button
                Section {
                    Button(action: {
                        addProduct()
                    }) {
                        Text("Add Product")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(isFormValid ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Add Product")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImages: $images)
            }
        }
    }
    
    // MARK: - Field validation

    private var titleError: String? {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return nil }
        if !InputValidator.isSafe(trimmed) { return "Title contains invalid characters." }
        if !InputValidator.isLengthValid(trimmed, maxLength: 100) { return "Title is too long." }
        return nil
    }

    private var priceError: String? {
        let trimmed = price.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return nil }
        guard let value = Double(trimmed) else { return "Enter a valid price." }
        if value <= 0 { return "Price must be greater than 0." }
        return nil
    }

    private var descriptionError: String? {
        let trimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return nil }
        if !InputValidator.isSafe(trimmed) { return "Description contains invalid characters." }
        if !InputValidator.isLengthValid(trimmed, maxLength: 2000) { return "Description is too long." }
        return nil
    }

    private var locationError: String? {
        let trimmed = location.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return nil }
        if !InputValidator.isSafe(trimmed) { return "Location contains invalid characters." }
        if !InputValidator.isLengthValid(trimmed, maxLength: 100) { return "Location is too long." }
        return nil
    }

    // Form validation check
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        titleError == nil && priceError == nil && descriptionError == nil && locationError == nil
    }
    
    // Adding a new product
    private func addProduct() {
        guard isFormValid,
              let priceValue = Double(price),
              let currentUser = sessionStore.currentUser else {
            return
        }
        
        // Create a new product
        let newProduct = Product(
            id: UUID().uuidString,
            title: title,
            description: description,
            price: priceValue,
            sellerId: currentUser.id,
            category: category,
            imageURLs: [] // In a real app, this would be URLs of uploaded images
        )
        
        // Add the product to the list
        dataManager.addProduct(newProduct)
        
        // Close the screen
        presentationMode.wrappedValue.dismiss()
    }
}
