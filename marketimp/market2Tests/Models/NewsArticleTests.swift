import XCTest
import FirebaseFirestore
@testable import market2

final class NewsArticleTests: XCTestCase {

    func testInitialization() {
        let article = NewsArticle(
            id: "article-1",
            title: "Patch Notes 1.2",
            content: "Balance changes and bug fixes.",
            authorId: "user-1",
            authorUsername: "Alex",
            imageURL: "https://example.com/patch.jpg",
            viewCount: 0,
            isPublished: true,
            createdAt: Timestamp(date: Date())
        )

        XCTAssertEqual(article.id, "article-1")
        XCTAssertEqual(article.title, "Patch Notes 1.2")
        XCTAssertEqual(article.authorId, "user-1")
        XCTAssertEqual(article.viewCount, 0)
        XCTAssertTrue(article.isPublished)
    }

    func testFilterPublishedArticles() {
        let published = NewsArticle(id: "a1", title: "Live", content: "", authorId: "u1", authorUsername: "A", imageURL: "", viewCount: 0, isPublished: true, createdAt: nil)
        let draft = NewsArticle(id: "a2", title: "Draft", content: "", authorId: "u1", authorUsername: "A", imageURL: "", viewCount: 0, isPublished: false, createdAt: nil)

        let visible = [published, draft].filter { $0.isPublished }

        XCTAssertEqual(visible.map { $0.id }, ["a1"])
    }
}
