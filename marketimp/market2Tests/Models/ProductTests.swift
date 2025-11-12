import XCTest
@testable import market2

class ProductTests: XCTestCase {
    
    // Test product initialization
    func testProductInitialization() {
        // Arrange
        let id = "test-id"
        let sellerId = "seller-id"
        let title = "iPhone 13"
        let description = "Excellent condition"
        let price: Double = 50000
        let category = "Electronics"
        let condition = "Excellent"
        let location = "Moscow"
        let imageURLs = ["url1", "url2"]
        let status = ProductStatus.active
        let createdAt = Date()
        
        // Act
        let product = Product(
            id: id,
            sellerId: sellerId,
            title: title,
            description: description,
            price: price,
            category: category,
            condition: condition,
            location: location,
            imageURLs: imageURLs,
            status: status,
            createdAt: createdAt
        )
        
        // Assert
        XCTAssertEqual(product.id, id)
        XCTAssertEqual(product.sellerId, sellerId)
        XCTAssertEqual(product.title, title)
        XCTAssertEqual(product.description, description)
        XCTAssertEqual(product.price, price)
        XCTAssertEqual(product.category, category)
        XCTAssertEqual(product.condition, condition)
        XCTAssertEqual(product.location, location)
        XCTAssertEqual(product.imageURLs, imageURLs)
        XCTAssertEqual(product.status, status)
        XCTAssertEqual(product.createdAt, createdAt)
    }
    
    // Test product status changes
    func testProductStatusChanges() {
        // Arrange
        var product = Product(
            id: "test-id",
            sellerId: "seller-id",
            title: "Test Product",
            description: "Test",
            price: 50000,
            category: "Electronics",
            condition: "New",
            location: "Moscow",
            imageURLs: [],
            status: .active,
            createdAt: Date()
        )
        
        // Act & Assert - check initial status
        XCTAssertEqual(product.status, .active)
        
        // Act - change status to "sold"
        product.status = .sold
        
        // Assert - check that status has changed
        XCTAssertEqual(product.status, .sold)
        
        // Act - change status to "reserved"
        product.status = .reserved
        
        // Assert - check that status has changed
        XCTAssertEqual(product.status, .reserved)
    }
    
    // Test product examples
    func testProductExamples() {
        // Act
        let examples = Product.examples
        
        // Assert
        XCTAssertEqual(examples.count, 3)
        
        // Check the first example
        XCTAssertEqual(examples[0].id, "product1")
        XCTAssertEqual(examples[0].title, "iPhone 13 Pro")
        XCTAssertEqual(examples[0].price, 65000)
        XCTAssertEqual(examples[0].category, "Electronics")
        XCTAssertEqual(examples[0].status, .active)
        
        // Check the second example
        XCTAssertEqual(examples[1].id, "product2")
        XCTAssertEqual(examples[1].title, "Nike Air Max Sneakers")
        XCTAssertEqual(examples[1].price, 5000)
        XCTAssertEqual(examples[1].category, "Clothing & Shoes")
        
        // Check the third example
        XCTAssertEqual(examples[2].id, "product3")
        XCTAssertEqual(examples[2].title, "Book 'The Master and Margarita'")
        XCTAssertEqual(examples[2].price, 800)
        XCTAssertEqual(examples[2].category, "Books")
    }
    
    // Test encoding and decoding (Codable)
    func testProductCodable() {
        // Arrange
        let originalProduct = Product(
            id: "test-id",
            sellerId: "seller-id",
            title: "Test Product",
            description: "Test description",
            price: 1500.50,
            category: "Test",
            condition: "New",
            location: "Test",
            imageURLs: ["url1", "url2"],
            status: .active,
            createdAt: Date()
        )
        
        // Act - encode product to JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try encoder.encode(originalProduct)
            
            // Decode JSON back to product
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedProduct = try decoder.decode(Product.self, from: jsonData)
            
            // Assert - check that the product after encoding/decoding is identical to the original
            XCTAssertEqual(decodedProduct.id, originalProduct.id)
            XCTAssertEqual(decodedProduct.sellerId, originalProduct.sellerId)
            XCTAssertEqual(decodedProduct.title, originalProduct.title)
            XCTAssertEqual(decodedProduct.description, originalProduct.description)
            XCTAssertEqual(decodedProduct.price, originalProduct.price)
            XCTAssertEqual(decodedProduct.category, originalProduct.category)
            XCTAssertEqual(decodedProduct.condition, originalProduct.condition)
            XCTAssertEqual(decodedProduct.location, originalProduct.location)
            XCTAssertEqual(decodedProduct.imageURLs, originalProduct.imageURLs)
            XCTAssertEqual(decodedProduct.status, originalProduct.status)
            
            // For date, we only check year, month and day, as milliseconds may differ
            let calendar = Calendar.current
            XCTAssertEqual(
                calendar.dateComponents([.year, .month, .day], from: decodedProduct.createdAt),
                calendar.dateComponents([.year, .month, .day], from: originalProduct.createdAt)
            )
            
        } catch {
            XCTFail("Failed to encode/decode Product: \(error)")
        }
    }
    
    // Test filtering products by category
    func testFilterProductsByCategory() {
        // Arrange
        let products = Product.examples
        
        // Act - filter by "Electronics" category
        let electronicsProducts = products.filter { $0.category == "Electronics" }
        
        // Assert
        XCTAssertEqual(electronicsProducts.count, 1)
        XCTAssertEqual(electronicsProducts[0].id, "product1")
        
        // Act - filter by "Books" category
        let booksProducts = products.filter { $0.category == "Books" }
        
        // Assert
        XCTAssertEqual(booksProducts.count, 1)
        XCTAssertEqual(booksProducts[0].id, "product3")
        
        // Act - filter by non-existent category
        let nonExistentCategory = products.filter { $0.category == "Non-existent" }
        
        // Assert
        XCTAssertEqual(nonExistentCategory.count, 0)
    }
    
    // Test filtering products by seller
    func testFilterProductsBySeller() {
        // Arrange
        let products = Product.examples
        
        // Act - filter by seller "user1"
        let user1Products = products.filter { $0.sellerId == "user1" }
        
        // Assert
        XCTAssertEqual(user1Products.count, 2)
        XCTAssertEqual(user1Products[0].id, "product1")
        XCTAssertEqual(user1Products[1].id, "product3")
        
        // Act - filter by seller "user2"
        let user2Products = products.filter { $0.sellerId == "user2" }
        
        // Assert
        XCTAssertEqual(user2Products.count, 1)
        XCTAssertEqual(user2Products[0].id, "product2")
    }
    
    // Test sorting products by price (ascending)
    func testSortProductsByPriceAscending() {
        // Arrange
        let products = Product.examples
        
        // Act
        let sortedProducts = products.sorted { $0.price < $1.price }
        
        // Assert
        XCTAssertEqual(sortedProducts.count, 3)
        XCTAssertEqual(sortedProducts[0].id, "product3") // 800
        XCTAssertEqual(sortedProducts[1].id, "product2") // 5000
        XCTAssertEqual(sortedProducts[2].id, "product1") // 65000
    }
    
    // Test sorting products by price (descending)
    func testSortProductsByPriceDescending() {
        // Arrange
        let products = Product.examples
        
        // Act
        let sortedProducts = products.sorted { $0.price > $1.price }
        
        // Assert
        XCTAssertEqual(sortedProducts.count, 3)
        XCTAssertEqual(sortedProducts[0].id, "product1") // 65000
        XCTAssertEqual(sortedProducts[1].id, "product2") // 5000
        XCTAssertEqual(sortedProducts[2].id, "product3") // 800
    }
}
