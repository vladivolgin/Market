import SwiftUI
import PhotosUI

class AddProductViewModel: ObservableObject {
    @Published var title = ""
    @Published var price = ""
    @Published var description = ""
    @Published var category = "Techs"
    @Published var condition = "great"
    @Published var location = ""
    @Published var selectedImages: [UIImage] = []
    @Published var isLoading = false
    @Published var showingSuccessAlert = false
    @Published var errorMessage: String?
    
    let categories = ["Techs", "Clothes", "Books", "Furniture", "Sport", "Others"]
    let conditions = ["New", "Great", "Good", "Alright"]
    
    var isFormValid: Bool {
        !title.isEmpty &&
        !price.isEmpty &&
        !location.isEmpty &&
        !description.isEmpty &&
        !selectedImages.isEmpty
    }
    
    func addProduct() {
        guard isFormValid else { return }
        
        isLoading = true
        
        // Simulate uploading to the server
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Creating a new product
            let newProduct = Product(
                id: UUID().uuidString,
                sellerId: "user1", // In the future application, this will be the ID of the current user
                title: self.title,
                description: self.description,
                price: Double(self.price) ?? 0,
                category: self.category,
                condition: self.condition,
                location: self.location,
                imageURLs: [], // In the future application, the URLs of the uploaded images will be displayed here.
                status: .active,
                createdAt: Date()
            )
            
            //  In the future application, there will be code here to save the product on the server.
            print("Item added: \(newProduct.title)")
            
            self.isLoading = false
            self.showingSuccessAlert = true
        }
    }
    
    func clearForm() {
        title = ""
        price = ""
        description = ""
        category = "Tech"
        condition = "Great"
        location = ""
        selectedImages = []
    }
}
