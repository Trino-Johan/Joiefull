import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProductViewModel()
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var selectedProduct: Product?
    @State private var columnVisibility = NavigationSplitViewVisibility.all

    // --- GRILLE RÉPONSIVE ---
    var columns: [GridItem] {
        if sizeClass == .compact {
            // Force 2 colonnes sur iPhone
            return [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
        } else {
            // Adaptatif sur iPad
            return [GridItem(.adaptive(minimum: 180), spacing: 20)]
        }
    }

    var body: some View {
        if selectedProduct == nil || sizeClass == .compact {
            NavigationStack {
                gridView
                    .navigationTitle("Joiefull")
                    .navigationDestination(item: $selectedProduct) { product in
                        if let index = viewModel.products.firstIndex(where: { $0.id == product.id }) {
                            ProductDetailView(
                                product: $viewModel.products[index],
                                viewModel: viewModel,
                                selectedProductId: .constant(nil)
                            )
                        }
                    }
            }
            .task { await viewModel.loadData() }
        } else {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                gridView
                    .navigationTitle("Joiefull")
                    .navigationSplitViewColumnWidth(min: 450, ideal: 550, max: 700)
            } detail: {
                if let product = selectedProduct,
                   let index = viewModel.products.firstIndex(where: { $0.id == product.id }) {
                    ProductDetailView(
                        product: $viewModel.products[index],
                        viewModel: viewModel,
                        selectedProductId: .constant(nil)
                    )
                }
            }
            .navigationSplitViewStyle(.balanced)
        }
    }

    var gridView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                ForEach(viewModel.categories, id: \.self) { category in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(category.uppercased())
                            .font(.system(size: 24, weight: .black))
                            .padding(.horizontal)
                        
                        // Utilisation des colonnes réponsives ici
                        LazyVGrid(columns: columns, spacing: 25) {
                            ForEach($viewModel.products) { $product in
                                if product.category.lowercased() == category.lowercased() {
                                    Button(action: {
                                        withAnimation { selectedProduct = product }
                                    }) {
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
        }
    }
}
