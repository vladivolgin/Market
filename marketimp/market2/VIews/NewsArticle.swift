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
    
 
    @ServerTimestamp var createdAt: Timestamp?
  
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
