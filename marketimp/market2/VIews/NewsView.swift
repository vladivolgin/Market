import SwiftUI
import Firebase

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        NavigationView {
            if viewModel.articles.isEmpty {
                ProgressView("Loading news...")
                    .navigationTitle("News")
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.articles) { article in
                            NavigationLink(destination: NewsDetailView(article: article)) {
                                NewsRow(article: article)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .navigationTitle("News")
            }
        }
        .onAppear {
            viewModel.fetchNews()
        }
    }
}


struct NewsRow: View {
    let article: NewsArticle

    var body: some View {
    
        Color.clear
            .frame(minHeight: 250)
            .background {
               
                if let url = URL(string: article.imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fill)
                        default:
                            Color.gray.opacity(0.3)
                        }
                    }
                } else {
                    Color.gray.opacity(0.3)
                }
            }
            .overlay {
          
                ZStack(alignment: .bottomLeading) {
                    
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )

            
                    VStack(alignment: .leading, spacing: 8) {
                        Text(article.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(3)

                        Text(article.authorUsername)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.9))

                        HStack {
                            Label("\(article.viewCount)", systemImage: "eye.fill")
                            Spacer()
                            if let date = article.createdAt?.dateValue() {
                                Text(date, style: .date)
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                }
            }
            .clipped()
            .cornerRadius(15)
            .padding(.horizontal)
            .padding(.vertical, 8)
    }
}



