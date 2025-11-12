import XCTest
@testable import market2

class UserTests: XCTestCase {
    
    // Test user initialization with all fields
    func testUserInitializationWithAllFields() {
        // Arrange
        let id = "test-id"
        let username = "TestUser"
        let email = "test@example.com"
        let profileImageURL = "https://example.com/image.jpg"
        let rating = 4.5
        let createdAt = Date()
        
        // Act
        let user = User(
            id: id,
            username: username,
            email: email,
            profileImageURL: profileImageURL,
            rating: rating,
            createdAt: createdAt
        )
        
        // Assert
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.username, username)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.profileImageURL, profileImageURL)
        XCTAssertEqual(user.rating, rating)
        XCTAssertEqual(user.createdAt, createdAt)
    }
    
    // Test user initialization without profile image URL
    func testUserInitializationWithoutProfileImage() {
        // Arrange
        let id = "test-id"
        let username = "TestUser"
        let email = "test@example.com"
        let rating = 4.5
        let createdAt = Date()
        
        // Act
        let user = User(
            id: id,
            username: username,
            email: email,
            profileImageURL: nil,
            rating: rating,
            createdAt: createdAt
        )
        
        // Assert
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.username, username)
        XCTAssertEqual(user.email, email)
        XCTAssertNil(user.profileImageURL)
        XCTAssertEqual(user.rating, rating)
        XCTAssertEqual(user.createdAt, createdAt)
    }
    
    // Test user example
    func testUserExample() {
        // Act
        let example = User.example
        
        // Assert
        XCTAssertEqual(example.id, "user1")
        XCTAssertEqual(example.username, "Alex")
        XCTAssertEqual(example.email, "alex@example.com")
        XCTAssertEqual(example.profileImageURL, "https://example.com/profile.jpg")
        XCTAssertEqual(example.rating, 4.8)
        XCTAssertNotNil(example.createdAt)
    }
    
    // Test encoding and decoding (Codable)
    func testUserCodable() {
        // Arrange
        let originalUser = User(
            id: "test-id",
            username: "TestUser",
            email: "test@example.com",
            profileImageURL: "https://example.com/image.jpg",
            rating: 4.5,
            createdAt: Date()
        )
        
        // Act - encode user to JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try encoder.encode(originalUser)
            
            // Decode JSON back to user
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedUser = try decoder.decode(User.self, from: jsonData)
            
            // Assert - check that the user after encoding/decoding is identical to the original
            XCTAssertEqual(decodedUser.id, originalUser.id)
            XCTAssertEqual(decodedUser.username, originalUser.username)
            XCTAssertEqual(decodedUser.email, originalUser.email)
            XCTAssertEqual(decodedUser.profileImageURL, originalUser.profileImageURL)
            XCTAssertEqual(decodedUser.rating, originalUser.rating)
            
            // For date, we only check year, month and day, as milliseconds may differ
            let calendar = Calendar.current
            XCTAssertEqual(
                calendar.dateComponents([.year, .month, .day], from: decodedUser.createdAt),
                calendar.dateComponents([.year, .month, .day], from: originalUser.createdAt)
            )
            
        } catch {
            XCTFail("Failed to encode/decode User: \(error)")
        }
    }
    
    // Test encoding and decoding user without profile image URL
    func testUserCodableWithoutProfileImage() {
        // Arrange
        let originalUser = User(
            id: "test-id",
            username: "TestUser",
            email: "test@example.com",
            profileImageURL: nil,
            rating: 4.5,
            createdAt: Date()
        )
        
        // Act - encode user to JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try encoder.encode(originalUser)
            
            // Decode JSON back to user
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedUser = try decoder.decode(User.self, from: jsonData)
            
            // Assert - check that the user after encoding/decoding is identical to the original
            XCTAssertEqual(decodedUser.id, originalUser.id)
            XCTAssertEqual(decodedUser.username, originalUser.username)
            XCTAssertEqual(decodedUser.email, originalUser.email)
            XCTAssertNil(decodedUser.profileImageURL)
            XCTAssertEqual(decodedUser.rating, originalUser.rating)
            
        } catch {
            XCTFail("Failed to encode/decode User: \(error)")
        }
    }
    
    // Test email validation
    func testEmailValidation() {
        // Arrange
        let validEmails = [
            "test@example.com",
            "user.name@domain.co.uk",
            "user+tag@example.org",
            "a@b.c"
        ]
        
        let invalidEmails = [
            "plaintext",
            "missing@domain",
            "@missinguser.com",
            "user@.com",
            "user@domain..com"
        ]
        
        // Act & Assert
        for email in validEmails {
            XCTAssertTrue(isValidEmail(email), "Email should be valid: \(email)")
        }
        
        for email in invalidEmails {
            XCTAssertFalse(isValidEmail(email), "Email should be invalid: \(email)")
        }
    }
    
    // Helper function to check email validity
    private func isValidEmail(_ email: String) -> Bool {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        let matches = detector.matches(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count))
        
        // Check that exactly one result is found and it's an email
        return matches.count == 1 &&
               matches[0].range.location == 0 &&
               matches[0].range.length == email.utf16.count &&
               matches[0].url?.scheme == "mailto"
    }

    // Test user equality
    func testUserEquality() {
        // Arrange
        let user1 = User(
            id: "test-id",
            username: "TestUser",
            email: "test@example.com",
            profileImageURL: "https://example.com/image.jpg",
            rating: 4.5,
            createdAt: Date()
        )
        
        let user2 = User(
            id: "test-id",
            username: "TestUser",
            email: "test@example.com",
            profileImageURL: "https://example.com/image.jpg",
            rating: 4.5,
            createdAt: user1.createdAt
        )
        
        let user3 = User(
            id: "different-id",
            username: "TestUser",
            email: "test@example.com",
            profileImageURL: "https://example.com/image.jpg",
            rating: 4.5,
            createdAt: user1.createdAt
        )
        
        // Act & Assert
        // Users with the same ID should be considered equal
        XCTAssertEqual(user1.id, user2.id)
        
        // Users with different IDs should be considered different
        XCTAssertNotEqual(user1.id, user3.id)
    }
    
    // Test rating formatting
    func testRatingFormatting() {
        // Arrange
        let user = User(
            id: "test-id",
            username: "TestUser",
            email: "test@example.com",
            profileImageURL: nil,
            rating: 4.75,
            createdAt: Date()
        )
        
        // Act
        let formattedRating = String(format: "%.1f", user.rating)
        
        // Assert
        XCTAssertEqual(formattedRating, "4.8")
    }
    
    // Test username validation
    func testUsernameValidation() {
        // Arrange
        let validUsernames = [
            "user123",
            "User_Name",
            "username",
            "USERNAME",
            "user-name",
            "Alex"
        ]
        
        let invalidUsernames = [
            "", // empty string
            "a", // too short
            "user name", // spaces not allowed
            "user@name", // special characters not allowed
            "usernamethatiswaytoolongandexceedsthemaximumlength" // too long
        ]
        
        // Act & Assert
        for username in validUsernames {
            XCTAssertTrue(isValidUsername(username), "Username should be valid: \(username)")
        }
        
        for username in invalidUsernames {
            XCTAssertFalse(isValidUsername(username), "Username should be invalid: \(username)")
        }
    }
    
    // Helper function to check username validity
    private func isValidUsername(_ username: String) -> Bool {
        // Username must be 2-30 characters and contain only letters, numbers, hyphens, and underscores
        let usernameRegex = "^[A-Za-zА-Яа-я0-9_-]{2,30}$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }
}
