import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    let participantIds: [String]
    let lastMessage: String?
    @ServerTimestamp var lastMessageTimestamp: Timestamp?
    
    
    var otherParticipantId: String? {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return nil }
        return participantIds.first(where: { $0 != currentUserId })
    }
}
