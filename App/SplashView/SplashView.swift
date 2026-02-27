import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView() // Une fois fini, on bascule sur la liste
        } else {
            ZStack {
                Color("JoiefullOrange")
                    .ignoresSafeArea()
                
                VStack {
                    Text("Joiefull")
                        .font(.custom("Futura-Bold", size: 48))
                        .foregroundColor(.white)
                }
                .scaleEffect(opacity == 1.0 ? 1.1 : 1.0)
                .opacity(opacity)
            }
            .accessibilityLabel("Écran de chargement Joiefull")
            .onAppear {
                // Animation pour le logo
                withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0)) {
                    self.opacity = 1.0
                }
                
                // Transition vers la suite
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
