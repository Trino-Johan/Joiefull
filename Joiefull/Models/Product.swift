import Foundation

struct Product: Identifiable, Codable {
    let id: Int
    let name: String
    let category: String
    let price: Double
    let originalPrice: Double
    var likes: Int // var pour le compteur
    let picture: Picture
    

    var averageRating: Double = 4.0
    var ratingCount: Int = 70
    var userHasRated: Bool = false
    var isLiked: Bool = false
    var userRating: Int = 0 // Pour que tes étoiles restent remplies

    var comments: [String] = []
    
    struct Picture: Codable {
        let url: String
        let description: String
    }

    enum CodingKeys: String, CodingKey {
        case id, name, category, price, likes, picture
        case originalPrice = "original_price"
    }
}
