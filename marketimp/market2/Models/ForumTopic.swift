import Foundation

struct ForumTopic: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let postCount: Int
}
