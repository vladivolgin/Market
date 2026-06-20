import XCTest
@testable import market2

final class UserTests: XCTestCase {

    func testInitialization() {
        let createdAt = Date()
        let user = User(
            id: "user-1",
            username: "Alex",
            email: "alex@example.com",
            profileImageURL: "https://example.com/image.jpg",
            rating: 4.5,
            createdAt: createdAt
        )

        XCTAssertEqual(user.id, "user-1")
        XCTAssertEqual(user.username, "Alex")
        XCTAssertEqual(user.email, "alex@example.com")
        XCTAssertEqual(user.profileImageURL, "https://example.com/image.jpg")
        XCTAssertEqual(user.rating, 4.5)
        XCTAssertEqual(user.createdAt, createdAt)
    }

    func testInitializationWithoutProfileImage() {
        let user = User(
            id: "user-1",
            username: "Alex",
            email: "alex@example.com",
            profileImageURL: nil,
            rating: 4.5,
            createdAt: Date()
        )

        XCTAssertNil(user.profileImageURL)
    }

    func testExample() {
        let example = User.example

        XCTAssertEqual(example.id, "user1")
        XCTAssertEqual(example.username, "Alex")
        XCTAssertEqual(example.email, "alex@example.com")
        XCTAssertEqual(example.rating, 4.8)
    }

    func testCodableRoundTrip() {
        let original = User(
            id: "user-1",
            username: "Alex",
            email: "alex@example.com",
            profileImageURL: "https://example.com/image.jpg",
            rating: 4.5,
            createdAt: Date()
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let data = try encoder.encode(original)
            let decoded = try decoder.decode(User.self, from: data)

            XCTAssertEqual(decoded.id, original.id)
            XCTAssertEqual(decoded.username, original.username)
            XCTAssertEqual(decoded.email, original.email)
            XCTAssertEqual(decoded.profileImageURL, original.profileImageURL)
            XCTAssertEqual(decoded.rating, original.rating)

            // Round-tripping through ISO8601 truncates sub-second precision.
            let calendar = Calendar.current
            XCTAssertEqual(
                calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: decoded.createdAt),
                calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: original.createdAt)
            )
        } catch {
            XCTFail("Failed to encode/decode User: \(error)")
        }
    }

    func testCodableRoundTripWithoutProfileImage() {
        let original = User(
            id: "user-1",
            username: "Alex",
            email: "alex@example.com",
            profileImageURL: nil,
            rating: 4.5,
            createdAt: Date()
        )

        do {
            let data = try JSONEncoder().encode(original)
            let decoded = try JSONDecoder().decode(User.self, from: data)
            XCTAssertNil(decoded.profileImageURL)
        } catch {
            XCTFail("Failed to encode/decode User: \(error)")
        }
    }
}
