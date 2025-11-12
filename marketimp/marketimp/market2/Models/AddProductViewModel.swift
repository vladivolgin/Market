import SwiftUI
import PhotosUI

class AddProductViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var title = ""
    @Published var price = ""
    @Published var description = ""
    @Published var category = "Tech"
    
    @Published var selectedImages: [UIImage] = []
    @Published var isLoading = false
    @Published var showingSuccessAlert = false
    @Published var errorMessage: String?
    
    // MARK: - Static Data
    let categories = ["Tech", "Clothes", "Books", "Furniture", "Sport", "Others"]
    
    // MARK: - Computed Properties
    var isFormValid: Bool {
        !title.isEmpty &&
        !price.isEmpty &&
        !description.isEmpty &&
        !selectedImages.isEmpty
    }
    
    // MARK: - Functions
    func addProduct() {
        guard isFormValid else { return }
        
        isLoading = true
        
        // Имитируем загрузку на сервер
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Создаем упрощенный продукт с правильным порядком аргументов
            let newProduct = Product(
                id: UUID().uuidString,
                title: self.title,
                description: self.description,
                price: Double(self.price) ?? 0,
                sellerId: "user123",
                category: self.category,
                imageURLs: []
            )
            
            print("✅ Item added (locally): \(newProduct.title)")
            
            self.isLoading = false
            self.showingSuccessAlert = true
        }
    }
    
    func clearForm() {
        title = ""
        price = ""
        description = ""
        category = "Tech"
        selectedImages = []
    }
}
