import SwiftUI
import PhotosUI

class AddProductViewModel: ObservableObject {
    @Published var title = ""
    @Published var price = ""
    @Published var description = ""
    @Published var category = "Электроника"
    @Published var condition = "Отличное"
    @Published var location = ""
    @Published var selectedImages: [UIImage] = []
    @Published var isLoading = false
    @Published var showingSuccessAlert = false
    @Published var errorMessage: String?
    
    let categories = ["Электроника", "Одежда и обувь", "Книги", "Мебель", "Спорт", "Другое"]
    let conditions = ["Новое", "Отличное", "Хорошее", "Удовлетворительное"]
    
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
        
        // Имитация загрузки на сервер
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Создаем новый товар
            let newProduct = Product(
                id: UUID().uuidString,
                sellerId: "user1", // В реальном приложении это будет ID текущего пользователя
                title: self.title,
                description: self.description,
                price: Double(self.price) ?? 0,
                category: self.category,
                condition: self.condition,
                location: self.location,
                imageURLs: [], // В реальном приложении здесь будут URL загруженных изображений
                status: .active,
                createdAt: Date()
            )
            
            // В реальном приложении здесь будет код для сохранения товара на сервере
            print("Товар добавлен: \(newProduct.title)")
            
            self.isLoading = false
            self.showingSuccessAlert = true
        }
    }
    
    func clearForm() {
        title = ""
        price = ""
        description = ""
        category = "Электроника"
        condition = "Отличное"
        location = ""
        selectedImages = []
    }
}
