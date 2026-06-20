import Foundation
@testable import market2

struct ProductFactory {
    static func create(
        id: String? = UUID().uuidString,
        title: String = "Test Product",
        description: String = "Test description",
        price: Double = 1000.0,
        sellerId: String = "seller-id",
        category: String = "Test Category",
        imageURLs: [String] = []
    ) -> Product {
        Product(
            id: id,
            title: title,
            description: description,
            price: price,
            sellerId: sellerId,
            category: category,
            imageURLs: imageURLs
        )
    }
}
