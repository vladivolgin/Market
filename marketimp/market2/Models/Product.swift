import Foundation

struct Product: Identifiable, Codable {
    var id: String
    var sellerId: String
    var title: String
    var description: String
    var price: Double
    var category: String
    var condition: String
    var location: String
    var imageURLs: [String]
    var status: ProductStatus
    var createdAt: Date
    
    // Для тестирования
    static let examples = [
        Product(
            id: "product1",
            sellerId: "user1",
            title: "iPhone 13 Pro",
            description: "Отличное состояние, полный комплект, на гарантии",
            price: 65000,
            category: "Электроника",
            condition: "Отличное",
            location: "Москва",
            imageURLs: [],
            status: .active,
            createdAt: Date()
        ),
        Product(
            id: "product2",
            sellerId: "user2",
            title: "Кроссовки Nike Air Max",
            description: "Размер 42, почти новые",
            price: 5000,
            category: "Одежда и обувь",
            condition: "Хорошее",
            location: "Санкт-Петербург",
            imageURLs: [],
            status: .active,
            createdAt: Date()
        ),
        Product(
            id: "product3",
            sellerId: "user1",
            title: "Книга 'Мастер и Маргарита'",
            description: "Издание 2020 года, в твердом переплете",
            price: 800,
            category: "Книги",
            condition: "Новое",
            location: "Москва",
            imageURLs: [],
            status: .active,
            createdAt: Date()
        )
    ]
}

enum ProductStatus: String, Codable {
    case active = "active"
    case sold = "sold"
    case reserved = "reserved"
}
