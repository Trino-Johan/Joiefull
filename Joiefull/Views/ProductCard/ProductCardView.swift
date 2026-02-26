import SwiftUI

struct ProductCardView: View {
    @Binding var product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 1. Image avec le bouton Like
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
                
                // bouton Like avec le compteur
                LikeButtonView(product: $product)
                    .padding(8)
                    // label spécifique au bouton pour VoiceOver
                    .accessibilityLabel(product.isLiked ? "Retirer des favoris" : "Ajouter aux favoris")
            }
            
            // 2. Informations du produit
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(product.name)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)
                    
                    Spacer()
                    
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
        // --- CONFIGURATION ACCESSIBILITÉ ---
        .accessibilityElement(children: .combine) // Fusionne les textes en une seule annonce
        .accessibilityLabel(
            "\(product.name), prix \(String(format: "%.0f", product.price)) euros, note \(String(format: "%.1f", product.averageRating)) sur 5"
        )
        .accessibilityHint("Double-cliquez pour voir les détails")
    }
}
