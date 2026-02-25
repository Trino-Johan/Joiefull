import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProductViewModel()
    @Environment(\.horizontalSizeClass) var sizeClass
    
    // Grille : 2 colonnes sur iPhone, 3 sur iPad
    var columns: [GridItem] {
        let count = (sizeClass == .regular) ? 5 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(viewModel.categories, id: \.self) { category in
                    VStack(alignment: .leading) {
                        Text(category.uppercased())
                            .font(.system(size: 22, weight: .black))
                            .padding(.horizontal)
                            .padding(.top, 20)
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach($viewModel.products) { $product in
                                // On utilise product.wrappedValue pour le test de catégorie
                                if product.wrappedValue.category == category {
                                    NavigationLink(destination: ProductDetailView(product: $product, viewModel: viewModel)) {
                                        ProductCardView(product: $product)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Joiefull")
            .task { await viewModel.loadData() }
        }
    }
}
