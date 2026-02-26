import SwiftUI

struct ProductCardView: View {
    @Binding var product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 1. Image avec le bouton Like en bas à droite
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: product.picture.url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(15)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 180)
                        .cornerRadius(15)
                        .overlay(ProgressView())
                }
                .accessibilityLabel(product.picture.description)
                
                // bouton Like avec le compteur
                LikeButtonView(product: $product)
                    .padding(8)
            }
            
            // 2. Informations du produit (Nom, Prix et étoiles)
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(product.name)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Affichage de la note avec une étoile orange
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                        Text(String(format: "%.1f", product.averageRating))
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                }
                
                HStack {
                    Text("\(String(format: "%.0f", product.price))€")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    // Prix original barré si en promotion
                    if product.price < product.originalPrice {
                        Text("\(String(format: "%.0f", product.originalPrice))€")
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Double-cliquez pour voir les détails")
    }
}
