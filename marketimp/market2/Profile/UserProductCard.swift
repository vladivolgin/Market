import SwiftUI

struct UserProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            // Product image (оставляем как есть, это заглушка)
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
                
                // Используем Double для цены, как в нашей новой модели
                Text("\(product.price, specifier: "%.2f") $")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // --- ИЗМЕНЕНИЕ ---
                // Мы полностью удалили блок, который отображал статус,
                // так как этого поля больше нет в нашей модели Product.
                
            }
            .frame(width: 120)
        }
        .padding(.bottom, 8)
    }
    
    // --- ИЗМЕНЕНИЕ ---
    // Вспомогательные функции statusColor и расширение для ProductStatus
    // были полностью удалены, так как они больше не используются.
}
