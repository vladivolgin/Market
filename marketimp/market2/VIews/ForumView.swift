import SwiftUI

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
    
    
    struct ForumTopicRow: View {
        let topic: ForumTopic
        
        var body: some View {
            HStack(spacing: 15) {
                Image(systemName: topic.iconName)
                    .font(.title)
                    .foregroundColor(.accentColor)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(topic.title)
                        .font(.headline)
                    
                    Text(topic.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack {
                    Text("\(topic.postCount)")
                        .font(.headline)
                    Text("постов")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
    }
    
    struct TopicDetailView: View {
        let topic: ForumTopic
        
        var body: some View {
            Text("Скоро здесь появятся посты из раздела \"\(topic.title)\".")
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
