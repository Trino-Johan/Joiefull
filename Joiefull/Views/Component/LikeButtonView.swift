import SwiftUI

struct LikeButtonView: View {
    // Binding pour modifier le produit "pour de vrai"
    @Binding var product: Product

    var body: some View {
        Button(action: {
            // logique pour simuler le like
            product.isLiked.toggle()
            // triche un peu sur le compteur pour l'effet visuel immédiat
            if product.isLiked { product.likes += 1 } else { product.likes -= 1 }
        }) {
            HStack(spacing: 5) {
                Image(systemName: product.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(product.isLiked ? .red : .black)
                Text("\(product.likes)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .accessibilityLabel(product.isLiked ? "Je n'aime plus. \(product.likes) j'aimes." : "J'aime. \(product.likes) j'aimes.")
    }
}
