import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct NewsArticle: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let title: String
    let content: String
    let authorId: String
    let authorUsername: String
    let imageURL: String
    let viewCount: Int
    let isPublished: Bool
    
    // ИСПРАВЛЕНО: Меняем Timestamp? на String?, чтобы соответствовать Firebase
    @ServerTimestamp var createdAt: Timestamp?
    
    // Enum CodingKeys теперь не обязателен, так как имена полей совпадают,
    // но его можно оставить для ясности.
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case authorId
        case authorUsername
        case imageURL
        case viewCount
        case isPublished
        case createdAt
    }
}
