import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let senderId: String
    let text: String
    @ServerTimestamp var timestamp: Timestamp? 
}
