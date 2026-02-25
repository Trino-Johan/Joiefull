import Foundation

class ProductService {
    // L'URL du dépôt GitHub pour l'API
    private let urlString = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api/clothes.json"
    
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // On vérifie le code de réponse HTTP
        if let httpResponse = response as? HTTPURLResponse {
            print("🌐 Status Code : \(httpResponse.statusCode)")
            if httpResponse.statusCode != 200 {
                throw URLError(.fileDoesNotExist)
            }
        }
        
        // Petit debug : on affiche un bout de ce qu'on a reçu
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📄 Données reçues : \(jsonString.prefix(100))...")
        }
        
        let products = try JSONDecoder().decode([Product].self, from: data)
        return products
    }
}
