import XCTest
import FirebaseFirestore
@testable import market2

final class ChatTests: XCTestCase {

    func testInitialization() {
        let timestamp = Timestamp(date: Date())
        let chat = Chat(
            id: "chat-1",
            participantIds: ["user-1", "user-2"],
            lastMessage: "Hello!",
            lastMessageTimestamp: timestamp
        )

        XCTAssertEqual(chat.id, "chat-1")
        XCTAssertEqual(chat.participantIds, ["user-1", "user-2"])
        XCTAssertEqual(chat.lastMessage, "Hello!")
        XCTAssertEqual(chat.lastMessageTimestamp, timestamp)
    }

    func testInitializationWithoutLastMessage() {
        let chat = Chat(
            id: "chat-1",
            participantIds: ["user-1", "user-2"],
            lastMessage: nil,
            lastMessageTimestamp: nil
        )

        XCTAssertNil(chat.lastMessage)
        XCTAssertNil(chat.lastMessageTimestamp)
    }

    func testSortByLastMessageTimestamp() {
        let now = Date()
        let chat1 = Chat(id: "c1", participantIds: ["u1", "u2"], lastMessage: "a", lastMessageTimestamp: Timestamp(date: now.addingTimeInterval(-3600)))
        let chat2 = Chat(id: "c2", participantIds: ["u1", "u3"], lastMessage: "b", lastMessageTimestamp: Timestamp(date: now))
        let chat3 = Chat(id: "c3", participantIds: ["u1", "u4"], lastMessage: nil, lastMessageTimestamp: nil)

        let sorted = [chat1, chat2, chat3].sorted {
            ($0.lastMessageTimestamp?.dateValue() ?? .distantPast) > ($1.lastMessageTimestamp?.dateValue() ?? .distantPast)
        }

        XCTAssertEqual(sorted.map { $0.id }, ["c2", "c1", "c3"])
    }
}
