import Foundation
import Firebase
import FirebaseFirestoreSwift

class NewsViewModel: ObservableObject {
    @Published var articles = [NewsArticle]()
    private var db = Firestore.firestore()

    func fetchNews() {
        db.collection("News")
          .whereField("isPublished", isEqualTo: true)
          .order(by: "createdAt", descending: true)
          .addSnapshotListener { (querySnapshot, error) in
              if error != nil { // <--- Вот здесь
                  print(">>>>>> ОШИБКА FIREBASE: \\(error.localizedDescription)")
                  return
              }
            guard let documents = querySnapshot?.documents else {
                print(">>>>>> Документы не найдены.")
                return
            }
            self.articles = documents.compactMap { document -> NewsArticle? in
                do {
                    return try document.data(as: NewsArticle.self)
                } catch {
                    print(">>>>>> ОШИБКА ДЕКОДИРОВАНИЯ для \\(document.documentID): \\(error)")
                    return nil
                }
            }
        }
    }
}
