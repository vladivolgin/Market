import XCTest
@testable import market2

final class ProductTests: XCTestCase {

    func testInitialization() {
        let product = Product(
            id: "product-1",
            title: "iPhone 13",
            description: "Excellent condition",
            price: 50000,
            sellerId: "seller-1",
            category: "Electronics",
            imageURLs: ["url1", "url2"]
        )

        XCTAssertEqual(product.id, "product-1")
        XCTAssertEqual(product.title, "iPhone 13")
        XCTAssertEqual(product.description, "Excellent condition")
        XCTAssertEqual(product.price, 50000)
        XCTAssertEqual(product.sellerId, "seller-1")
        XCTAssertEqual(product.category, "Electronics")
        XCTAssertEqual(product.imageURLs, ["url1", "url2"])
    }

    func testInitializationWithNilId() {
        // Firestore assigns the document ID server-side, so a freshly
        // built product (before it's been written) has no id yet.
        let product = Product(
            id: nil,
            title: "New Product",
            description: "Not yet saved",
            price: 100,
            sellerId: "seller-1",
            category: "Other",
            imageURLs: []
        )

        XCTAssertNil(product.id)
    }

    func testFilterProductsByCategory() {
        let products = [
            ProductFactory.create(id: "p1", category: "Electronics"),
            ProductFactory.create(id: "p2", category: "Books"),
            ProductFactory.create(id: "p3", category: "Electronics")
        ]

        let electronics = products.filter { $0.category == "Electronics" }

        XCTAssertEqual(electronics.count, 2)
        XCTAssertTrue(electronics.allSatisfy { $0.category == "Electronics" })
    }

    func testSortProductsByPriceAscending() {
        let products = [
            ProductFactory.create(id: "p1", price: 5000),
            ProductFactory.create(id: "p2", price: 800),
            ProductFactory.create(id: "p3", price: 65000)
        ]

        let sorted = products.sorted { $0.price < $1.price }

        XCTAssertEqual(sorted.map(\.id), ["p2", "p1", "p3"])
    }
}
