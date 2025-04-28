import Foundation
@testable import market2  // Imports main module with @testable marked

struct ProductFactory {
    static func create(id: String = UUID().uuidString,
                      title: String = "Test Product",
                      price: Double = 1000.0) -> Product {
        return Product(
            id: id,
            sellerId: "seller-id",
            title: title,
            description: "Test description",
            price: price,
            category: "Test Category",
            condition: "New",
            location: "Test Location",
            imageURLs: [],
            status: .active,
            createdAt: Date()
        )
    }
    
    static func createCollection(count: Int = 3) -> [Product] {
        return (0..<count).map { i in
            create(id: "product-\(i)", title: "Product \(i)", price: Double(1000 * (i + 1)))
        }
    }
}

