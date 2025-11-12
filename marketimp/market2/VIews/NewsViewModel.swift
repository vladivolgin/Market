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
                  print(">>>>>> FIREBASE ERROR: \\(error.localizedDescription)")
                  return
              }
            guard let documents = querySnapshot?.documents else {
                print(">>>>>> No documents found.")
                return
            }
            self.articles = documents.compactMap { document -> NewsArticle? in
                do {
                    return try document.data(as: NewsArticle.self)
                } catch {
                    print(">>>>>> Decoding error for  \\(document.documentID): \\(error)")
                    return nil
                }
            }
        }
    }
}
