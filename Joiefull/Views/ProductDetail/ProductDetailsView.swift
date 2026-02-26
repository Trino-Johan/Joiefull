import SwiftUI

struct ProductDetailView: View {
    @Binding var product: Product
    @ObservedObject var viewModel: ProductViewModel
    @State private var commentText: String = ""
    @Environment(\.dismiss) var dismiss
    @Binding var selectedProductId: Int?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 1. Image + Like
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: product.picture.url)) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: { ProgressView() }
                        .frame(maxHeight: 400).clipped()
                        .cornerRadius(15)
                        // ♿ Label pour l'image
                        .accessibilityLabel("Photo de l'article : \(product.name)")
                    
                    LikeButtonView(product: $product)
                        .padding()
                        // ♿ Trait pour indiquer que c'est un bouton
                        .accessibilityAddTraits(.isButton)
                        .accessibilityLabel(product.isLiked ? "Retirer des favoris" : "Ajouter aux favoris")
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    // 2. Infos Produit (Nom, Prix et Note moyenne)
                    HStack(alignment: .firstTextBaseline) {
                        Text(product.name).font(.title2).bold()
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill").foregroundColor(.orange)
                            Text(String(format: "%.1f", product.averageRating)).bold()
                        }
                        // ♿ On groupe le badge de note pour une lecture fluide
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Note moyenne : \(String(format: "%.1f", product.averageRating)) sur 5")
                    }
                    
                    HStack {
                        Text("\(String(format: "%.0f", product.price))€").font(.title3).bold()
                        Spacer()
                        if product.price < product.originalPrice {
                            Text("\(String(format: "%.0f", product.originalPrice))€")
                                .font(.subheadline)
                                .strikethrough()
                                .foregroundColor(.gray)
                                // ♿ Précision pour le prix barré
                                .accessibilityLabel("Prix d'origine : \(String(format: "%.0f", product.originalPrice)) euros")
                        }
                    }
                    // ♿ On groupe les prix
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Prix actuel : \(String(format: "%.0f", product.price)) euros")
                    
                    // 3. DESCRIPTION
                    Text(product.picture.description)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineSpacing(5)
                        // ♿ On indique que c'est le descriptif
                        .accessibilityLabel("Description du produit : \(product.picture.description)")
                    
                    // 4. ZONE COMMENTAIRE ET NOTATION
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            // 1. avatar
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.gray)
                                .accessibilityHidden(true)
                            
                            // 2. étoiles avec détection du clic
                            HStack(spacing: 5) {
                                ForEach(1...5, id: \.self) { index in
                                    Image(systemName: index <= product.userRating ? "star.fill" : "star")
                                        .foregroundColor(.orange)
                                        .font(.title3) // Un peu plus grand pour faciliter le clic
                                        .contentShape(Rectangle()) // Rend toute la zone cliquable
                                        .onTapGesture {
                                            
                                            viewModel.rateProduct(product, with: index)
                                            product.userRating = index
                                        }
                                }
                            }
                            // ♿ Accessibilité (Swipe haut/bas pour VoiceOver)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel("Votre note")
                            .accessibilityValue("\(product.userRating) étoiles sur 5")
                            .accessibilityAdjustableAction { direction in
                                switch direction {
                                case .increment:
                                    if product.userRating < 5 {
                                        viewModel.rateProduct(product, with: product.userRating + 1)
                                        product.userRating += 1
                                    }
                                case .decrement:
                                    if product.userRating > 0 {
                                        viewModel.rateProduct(product, with: product.userRating - 1)
                                        product.userRating -= 1
                                    }
                                @unknown default: break
                                }
                            }
                        }
                        
                        VStack(alignment: .trailing) {
                            TextField("Partagez ici vos impressions", text: $commentText)
                                .padding()
                                .frame(height: 80, alignment: .topLeading)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                                // ♿ Label pour le champ de texte
                                .accessibilityLabel("Écrire un commentaire")
                            
                            Button(action: {
                                viewModel.addComment(to: product, text: commentText)
                                commentText = ""
                            }) {
                                Text("Publier")
                                    // ... tes styles ...
                                    .background(commentText.isEmpty ? Color.gray : Color.orange)
                                    .cornerRadius(20)
                            }
                            .disabled(commentText.isEmpty)
                            // ♿ État du bouton
                            .accessibilityHint(commentText.isEmpty ? "Écrivez un message pour pouvoir publier" : "Publie votre commentaire")
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { selectedProductId = nil; dismiss() }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("Home")
                    }
                }
                .accessibilityLabel("Retour à l'accueil")
            }

            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Logique de partage système
                    let av = UIActivityViewController(activityItems: ["Regarde ce produit Joiefull : \(product.name)"], applicationActivities: nil)
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let root = scene.windows.first?.rootViewController {
                        root.present(av, animated: true)
                    }
                })
                {
                    Image(systemName: "square.and.arrow.up").foregroundColor(.black)
                }
            }
        }
    }
}
