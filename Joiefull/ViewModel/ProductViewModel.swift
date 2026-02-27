import SwiftUI
import Combine

@MainActor // pour que les mises à jour de l'UI se fassent sans bug
class ProductViewModel: ObservableObject {
    // Les données que la vue va surveiller
    @Published var products: [Product] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private let service = ProductService()
    
    // trie les catégories présentes dans les données
    var categories: [String] {
        let allCategories = products.map { $0.category }
        return Array(Set(allCategories)).sorted()
    }
    
    // Fonction pour récupérer les produits
    func loadData() async {
        guard products.isEmpty else { return }
        
        isLoading = true
        do {
            self.products = try await service.fetchProducts()
            self.errorMessage = nil
        } catch {
            print("❌ Erreur de chargement détaillée : \(error)")
            self.errorMessage = "Erreur, impossible de charger les vêtements."
        }
        isLoading = false
    }
    
    // obtenir uniquement les produits d'une catégorie (top,bottom,accesssories)
    func getProducts(for category: String) -> [Product] {
        return products.filter { $0.category == category }
    }
    
    func rateProduct(_ product: Product, with note: Int) {
        // 1. Trouver l'index du produit dans la liste
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            let currentProduct = products[index]
            
            // Empêcher de voter deux fois
            if !currentProduct.userHasRated {
                let totalPoints = (currentProduct.averageRating * Double(currentProduct.ratingCount)) + Double(note)
                let newCount = currentProduct.ratingCount + 1
                
                // 2. Mettre à jour le produit avec la nouvelle moyenne
                products[index].averageRating = totalPoints / Double(newCount)
                products[index].ratingCount = newCount
                products[index].userHasRated = true
                products[index].userRating = note
                
                print("⭐ Nouvelle moyenne pour \(product.name) : \(products[index].averageRating)")
            }
        }
    }
    
    func addComment(to product: Product, text: String) {
        // vérifie que le texte n'est pas vide
        guard !text.isEmpty else { return }
        
        // trouve le produit dans la liste principale
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            // ajoute le commentaire en haut de la liste
            products[index].comments.insert(text, at: 0)
            print("📝 Nouveau commentaire pour \(product.name) : \(text)")
        }
    }
}
