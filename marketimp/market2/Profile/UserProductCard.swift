import SwiftUI

struct UserProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
       
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
                
                
                Text("\(product.price, specifier: "%.2f") $")
                    .font(.headline)
                    .foregroundColor(.primary)
                
             
                
            }
            .frame(width: 120)
        }
        .padding(.bottom, 8)
    }
    
 
}
