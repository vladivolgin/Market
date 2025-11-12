import Foundation
import FirebaseFirestoreSwift

struct ForumTopic: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var initialPost: String
    var authorId: String
    var authorUsername: String
    var authorProfileImageURL: String
    var category: String
    var createdAt: Date
    var isPinned: Bool
    var lastReplyAt: Date?
    var replyCount: Int
}
