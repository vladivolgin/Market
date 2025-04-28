import SwiftUI

struct UserProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            // Product image
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 120)
                    .cornerRadius(8)
                
                Image(systemName: "photo")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
            }
            
            // Product information
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text("\(Int(product.price)) ₽")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(product.status.localizedString)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(statusColor(product.status))
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
            .frame(width: 120)
        }
        .padding(.bottom, 8)
    }
    
    private func statusColor(_ status: ProductStatus) -> Color {
        switch status {
        case .active:
            return .green
        case .sold:
            return .gray
        case .reserved:
            return .orange
        }
    }
}

// Extension for localized product status strings
extension ProductStatus {
    var localizedString: String {
        switch self {
        case .active:
            return "Active"
        case .sold:
            return "Sold"
        case .reserved:
            return "Reserved"
        }
    }
}
