import SwiftUI
import FirebaseFirestoreSwift

struct ForumView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            List(dataManager.forumTopics) { topic in
                NavigationLink(destination: TopicDetailView(topic: topic)) {
                    ForumTopicRow(topic: topic)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Forum")
            .onAppear {
                Task {
                    await dataManager.fetchForumTopics()
                }
            }
        }
    }
    
    // MARK: - ForumTopicRow Firestore
    struct ForumTopicRow: View {
        let topic: ForumTopic
        
        var body: some View {
            HStack(spacing: 15) {
                Image(systemName: "bubble.left.and.bubble.right")
                    .font(.title)
                    .foregroundColor(.accentColor)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(topic.title)
                        .font(.headline)
                    
                    Text(topic.initialPost)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Text(topic.category)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack {
                    Text("\(topic.replyCount)")
                        .font(.headline)
                    Text("Replies")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    // MARK: - TopicDetailView
    struct TopicDetailView: View {
        let topic: ForumTopic
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    HStack {
                        if let url = URL(string: topic.authorProfileImageURL) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().frame(width: 40, height: 40).clipShape(Circle())
                                default:
                                    Circle().fill(Color.gray.opacity(0.3)).frame(width: 40, height: 40)
                                }
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(topic.title).font(.title2).bold()
                            Text(topic.authorUsername).font(.subheadline).foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    
                 
                    HStack {
                        Text(topic.category).font(.caption).foregroundColor(.blue)
                        Spacer()
                        Text(topic.createdAt, style: .date).font(.caption).foregroundColor(.secondary)
                    }
                    
                    
                    Text(topic.initialPost)
                        .font(.body)
                        .padding(.vertical, 8)
                    
                    Divider()
                    
                    Text("Replies: \(topic.replyCount)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle(topic.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    struct ForumView_Previews: PreviewProvider {
        static var previews: some View {
            ForumView()
                .environmentObject(DataManager())
        }
    }
}
