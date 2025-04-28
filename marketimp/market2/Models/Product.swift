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
    
    // For testing
    static let examples = [
        Product(
            id: "product1",
            sellerId: "user1",
            title: "iPhone 13 Pro",
            description: "Excellent condition, complete set, under warranty",
            price: 650,
            category: "Techs",
            condition: "Great",
            location: "Berlin",
            imageURLs: [],
            status: .active,
            createdAt: Date()
        ),
        Product(
            id: "product2",
            sellerId: "user2",
            title: "Nike Air Max",
            description: "Size 42, almost new",
            price: 50,
            category: "Clothes",
            condition: "Good",
            location: "Frankfurt am Main",
            imageURLs: [],
            status: .active,
            createdAt: Date()
        ),
        Product(
            id: "product3",
            sellerId: "user1",
            title: "Book'",
            description: "2020 edition, hardcover",
            price: 8,
            category: "Books",
            condition: "New",
            location: "Dortmund",
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
