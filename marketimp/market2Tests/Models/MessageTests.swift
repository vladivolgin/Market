import XCTest
import FirebaseFirestore
@testable import market2

final class MessageTests: XCTestCase {

    func testInitialization() {
        let timestamp = Timestamp(date: Date())
        let message = Message(
            id: "msg-1",
            senderId: "user-1",
            text: "Is this still available?",
            timestamp: timestamp
        )

        XCTAssertEqual(message.id, "msg-1")
        XCTAssertEqual(message.senderId, "user-1")
        XCTAssertEqual(message.text, "Is this still available?")
        XCTAssertEqual(message.timestamp, timestamp)
    }

    func testInitializationWithPendingTimestamp() {
        // Before Firestore assigns a server timestamp, the field is nil.
        let message = Message(
            id: nil,
            senderId: "user-1",
            text: "Hello",
            timestamp: nil
        )

        XCTAssertNil(message.id)
        XCTAssertNil(message.timestamp)
    }

    func testEquality() {
        let timestamp = Timestamp(date: Date())
        let message1 = Message(id: "msg-1", senderId: "user-1", text: "Hi", timestamp: timestamp)
        let message2 = Message(id: "msg-1", senderId: "user-1", text: "Hi", timestamp: timestamp)
        let message3 = Message(id: "msg-2", senderId: "user-1", text: "Hi", timestamp: timestamp)

        XCTAssertEqual(message1.id, message2.id)
        XCTAssertEqual(message1.text, message2.text)
        XCTAssertNotEqual(message1.id, message3.id)
    }

    func testSortByTimestamp() {
        let now = Date()
        let oldest = Message(id: "m1", senderId: "user-1", text: "Oldest", timestamp: Timestamp(date: now.addingTimeInterval(-3600)))
        let middle = Message(id: "m2", senderId: "user-1", text: "Middle", timestamp: Timestamp(date: now.addingTimeInterval(-1800)))
        let newest = Message(id: "m3", senderId: "user-1", text: "Newest", timestamp: Timestamp(date: now))

        let sorted = [newest, oldest, middle].sorted {
            ($0.timestamp?.dateValue() ?? .distantPast) < ($1.timestamp?.dateValue() ?? .distantPast)
        }

        XCTAssertEqual(sorted.map { $0.id }, ["m1", "m2", "m3"])
        XCTAssertSorted(sorted.map { $0.timestamp?.dateValue() ?? .distantPast })
    }
}
