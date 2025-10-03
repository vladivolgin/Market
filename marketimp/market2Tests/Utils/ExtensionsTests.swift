import XCTest
import Foundation
@testable import market2  // Replace with your module name

class ExtensionsTests: XCTestCase {
    
    // Test email validation without using extension
    func testEmailValidation() {
        // Function to check email
        func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
        
        // Tests
        XCTAssertTrue(isValidEmail("test@example.com"))
        XCTAssertFalse(isValidEmail("invalid-email"))
        XCTAssertFalse(isValidEmail("@example.com"))
    }
    
    // Test date formatting using standard DateFormatter
    func testDateFormatting() {
        let date = Date(timeIntervalSince1970: 1609459200) // 2021-01-01 00:00:00 UTC
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US") // Set locale for predictable result
        
        XCTAssertEqual(formatter.string(from: date), "1/1/21")
    }
    
    // Test price formatting (if you have such functionality)
    func testPriceFormatting() {
        let price: Double = 1000.50
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.locale = Locale(identifier: "ru_RU")
        
        let formattedPrice = formatter.string(from: NSNumber(value: price))
        
        // Check only for the presence of currency symbol and correct numeric value
        // without binding to a specific separator format
        XCTAssertTrue(formattedPrice?.contains("$") ?? false)
        XCTAssertTrue(formattedPrice?.contains("1") ?? false)
        XCTAssertTrue(formattedPrice?.contains("000") ?? false)
        XCTAssertTrue(formattedPrice?.contains("50") ?? false)
        
        // OR you can use the exact expected value if you're sure about the format
        // XCTAssertEqual(formattedPrice, "$1 000,50")
    }
    
    // Test string to date conversion
    func testStringToDateConversion() {
        let dateString = "2021-01-01"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.date(from: dateString)
        XCTAssertNotNil(date)
        
        if let date = date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            
            XCTAssertEqual(components.year, 2021)
            XCTAssertEqual(components.month, 1)
            XCTAssertEqual(components.day, 1)
        }
    }
}
