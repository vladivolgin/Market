import SwiftUI

struct NewsDetailView: View {
    let article: NewsArticle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let url = URL(string: article.imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 220)
                                .clipped()
                                .cornerRadius(16)
                        default:
                            Color.gray.opacity(0.3)
                                .frame(height: 220)
                                .cornerRadius(16)
                        }
                    }
                }

                
                Text(article.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                
                HStack {
                    Text(article.authorUsername)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Label("\(article.viewCount)", systemImage: "eye.fill")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if let date = article.createdAt?.dateValue() {
                        Text(date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                Divider().padding(.horizontal)

                
                Text(article.content)
                    .font(.body)
                    .padding(.horizontal)
                    .lineSpacing(4)

                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
