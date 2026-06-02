import SwiftUI

struct MaterialPickerView: View {
    let materials: [Material]
    let selected: Material?
    let onSelect: (Material) -> Void

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 10)], spacing: 10) {
            ForEach(materials) { mat in
                MaterialTile(
                    material: mat,
                    isSelected: selected?.id == mat.id,
                    action: { onSelect(mat) }
                )
            }
        }
    }
}

private struct MaterialTile: View {
    let material: Material
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.tertiarySystemBackground))
                    .frame(height: 50)
                    .overlay {
                        if let texturePath = material.texturePath {
                            AsyncImage(url: URL(string: AppConfig.baseURL + texturePath)) { img in
                                img.resizable().scaledToFill()
                            } placeholder: {
                                Image(systemName: "square.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Image(systemName: "square.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                isSelected ? Color.accentColor : Color.clear,
                                lineWidth: 2
                            )
                    )

                Text(material.displayName)
                    .font(.caption2)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(isSelected ? Color.accentColor : .primary)
            }
        }
        .buttonStyle(.plain)
    }
}
