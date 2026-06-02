import SwiftUI
import SceneKit

/// Placeholder 3D viewer — replace with RealityKit/SceneKit implementation.
/// When USDZ models are available, swap for a `RealityView` or `SceneView`.
struct ModelViewerPlaceholder: View {
    let configuration: BenchConfiguration

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(.systemGray6), Color(.systemGray5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 8) {
                Image(systemName: "cube.transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundStyle(.secondary)

                Text(configuration.series?.name ?? "Selecciona una serie")
                    .font(.headline)
                    .foregroundStyle(.primary)

                if let mat = configuration.material {
                    Text(mat.displayName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text("\(configuration.dimensions.widthInches)\" × \(configuration.dimensions.depthInches)\" × \(configuration.dimensions.heightInches)\"")
                    .font(.caption)
                    .foregroundStyle(.tertiary)

                Text("Vista 3D — requiere modelos USDZ")
                    .font(.caption2)
                    .foregroundStyle(.quaternary)
                    .padding(.top, 4)
            }
            .padding()
        }
        .clipShape(Rectangle())
    }
}

// MARK: - SceneKit real viewer (swap when USDZ models are ready)
// struct ModelViewerView: UIViewRepresentable {
//     let usdzURL: URL
//     func makeUIView(context: Context) -> SCNView {
//         let scnView = SCNView()
//         scnView.autoenablesDefaultLighting = true
//         scnView.allowsCameraControl = true
//         scnView.backgroundColor = .clear
//         scnView.scene = try? SCNScene(url: usdzURL)
//         return scnView
//     }
//     func updateUIView(_ uiView: SCNView, context: Context) {}
// }
