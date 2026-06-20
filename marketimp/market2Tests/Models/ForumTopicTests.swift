import XCTest
@testable import market2

final class ForumTopicTests: XCTestCase {

    func testInitialization() {
        let createdAt = Date()
        let topic = ForumTopic(
            id: "topic-1",
            title: "Best gaming chair?",
            initialPost: "Looking for recommendations.",
            authorId: "user-1",
            authorUsername: "Alex",
            authorProfileImageURL: "https://example.com/avatar.jpg",
            category: "Gear",
            createdAt: createdAt,
            isPinned: false,
            lastReplyAt: nil,
            replyCount: 0
        )

        XCTAssertEqual(topic.id, "topic-1")
        XCTAssertEqual(topic.title, "Best gaming chair?")
        XCTAssertEqual(topic.initialPost, "Looking for recommendations.")
        XCTAssertEqual(topic.authorId, "user-1")
        XCTAssertEqual(topic.category, "Gear")
        XCTAssertEqual(topic.createdAt, createdAt)
        XCTAssertFalse(topic.isPinned)
        XCTAssertNil(topic.lastReplyAt)
        XCTAssertEqual(topic.replyCount, 0)
    }

    func testPinnedTopicsSortFirst() {
        let now = Date()
        let pinned = ForumTopic(id: "t1", title: "Pinned", initialPost: "", authorId: "u1", authorUsername: "A", authorProfileImageURL: "", category: "General", createdAt: now.addingTimeInterval(-3600), isPinned: true, lastReplyAt: nil, replyCount: 0)
        let recent = ForumTopic(id: "t2", title: "Recent", initialPost: "", authorId: "u1", authorUsername: "A", authorProfileImageURL: "", category: "General", createdAt: now, isPinned: false, lastReplyAt: nil, replyCount: 0)
        let older = ForumTopic(id: "t3", title: "Older", initialPost: "", authorId: "u1", authorUsername: "A", authorProfileImageURL: "", category: "General", createdAt: now.addingTimeInterval(-7200), isPinned: false, lastReplyAt: nil, replyCount: 0)

        let sorted = [recent, older, pinned].sorted { lhs, rhs in
            if lhs.isPinned != rhs.isPinned { return lhs.isPinned }
            return lhs.createdAt > rhs.createdAt
        }

        XCTAssertEqual(sorted.map { $0.id }, ["t1", "t2", "t3"])
    }
}
