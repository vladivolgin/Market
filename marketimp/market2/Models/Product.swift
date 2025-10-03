import Foundation
import FirebaseFirestoreSwift

// Структура Product, которая ТОЧНО соответствует вашим данным в Firebase
struct Product: Identifiable, Codable {
    
    // Это свойство будет автоматически заполнено ID документа из Firebase
    @DocumentID var id: String?
    
    // Эти свойства должны точно совпадать с полями в вашей базе данных
    let title: String
    let description: String
    let price: Double // Используем Double для цены, так как в Firebase это Number
    let sellerId: String
    let category: String
    let imageURLs: [String]
    
    // --- ВАЖНО ---
    // Мы временно удалили поля condition, location, status, createdAt,
    // так как их нет в вашей базе данных, и они вызывают ошибку декодирования.
    
    
    // --- ПРИМЕЧАНИЕ ---
    // Чтобы этот пример снова работал, его нужно будет обновить,
    // убрав из него удаленные поля. Но для работы с Firebase он не нужен.
    /*
    static let examples = [
        Product( ... )
    ]
    */
}
