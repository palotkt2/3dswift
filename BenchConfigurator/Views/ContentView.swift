import SwiftUI

struct ContentView: View {
    @StateObject private var configuratorVM = ConfiguratorViewModel()
    @StateObject private var quoteVM = QuoteViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ConfiguratorView()
                .tabItem { Label("Configurar", systemImage: "wrench.and.screwdriver") }
                .tag(0)

            QuoteFormView()
                .tabItem { Label("Cotizar", systemImage: "doc.text") }
                .tag(1)
        }
        .environmentObject(configuratorVM)
        .environmentObject(quoteVM)
        .task { await configuratorVM.loadInitialData() }
    }
}

#Preview {
    ContentView()
}
