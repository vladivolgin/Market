import Foundation
import FirebaseFirestoreSwift


struct Product: Identifiable, Codable {
    

    @DocumentID var id: String?
    
   
    let title: String
    let description: String
    let price: Double 
    let sellerId: String
    let category: String
    let imageURLs: [String]

}
