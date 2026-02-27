import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let category: String
    let price: Double
    let originalPrice: Double
    var likes: Int // var pour le compteur
    let picture: Picture
    

    var averageRating: Double = 0.0
    var ratingCount: Int = 0
    var userHasRated: Bool = false
    var isLiked: Bool = false
    var userRating: Int = 0 // Pour que les étoiles puissent etre remplies

    var comments: [String] = []
    
    struct Picture: Codable, Hashable {
        let url: String
        let description: String
    }

    enum CodingKeys: String, CodingKey {
        case id, name, category, price, likes, picture
        case originalPrice = "original_price"
    }
}
