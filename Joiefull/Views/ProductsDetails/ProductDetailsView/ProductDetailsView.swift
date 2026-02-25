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
                // 1. Image + Like (ZStack pour superposer le bouton)
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: product.picture.url)) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: { ProgressView() }
                        .frame(maxHeight: 400).clipped()
                        .cornerRadius(15)
                    
                    LikeButtonView(product: $product)
                        .padding()
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
                    }
                    
                    HStack {
                        Text("\(String(format: "%.0f", product.price))€").font(.title3).bold()
                        
                        Spacer()
                        
                        if product.price < product.originalPrice {
                            Text("\(String(format: "%.0f", product.originalPrice))€")
                                .font(.subheadline)
                                .strikethrough()
                                .foregroundColor(.gray)
                            
                        }
                    }
                    
                    // 3. DESCRIPTION
                    Text(product.picture.description)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineSpacing(5)
                    
                    // 4. ZONE COMMENTAIRE ET PUBLICATION
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable().frame(width: 35, height: 35).foregroundColor(.gray)
                            
                            HStack(spacing: 2) {
                                ForEach(1...5, id: \.self) { index in
                                    Image(systemName: index <= product.userRating ? "star.fill" : "star")
                                        .foregroundColor(.orange)
                                        .onTapGesture { product.userRating = index }
                                }
                            }
                        }
                        
                        VStack(alignment: .trailing) {
                            TextField("Partagez ici vos impressions sur cette pièce", text: $commentText)
                                .padding()
                                .frame(height: 80, alignment: .topLeading)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            
                            // BOUTON PUBLIER
                            Button(action: {
                                viewModel.addComment(to: product, text: commentText)
                                commentText = "" // On vide le champ après publication
                            }) {
                                Text("Publier")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background(commentText.isEmpty ? Color.gray : Color.orange)
                                    .cornerRadius(20)
                            }
                            .disabled(commentText.isEmpty) // Désactivé si le texte est vide
                        }
                        
                        // AFFICHAGE DES COMMENTAIRES PUBLIÉS
                        if !product.comments.isEmpty {
                            Text("Commentaires (\(product.comments.count))")
                                .font(.headline)
                                .padding(.top, 10)
                            
                            ForEach(product.comments, id: \.self) { comment in
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: "person.circle.fill")
                                        .foregroundColor(.gray.opacity(0.5))
                                    Text(comment)
                                        .font(.subheadline)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    .padding(.top, 10)
                    .navigationBarBackButtonHidden(true)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    selectedProductId = nil
                    dismiss() }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("Home")
                    }
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                }
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
