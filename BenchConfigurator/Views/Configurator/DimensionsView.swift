import SwiftUI

struct DimensionsView: View {
    @Binding var dimensions: CustomDimensions

    // Width options in inches
    private let widthOptions = [48, 60, 72, 84, 96]
    private let depthOptions = [24, 27, 30, 33, 36]
    private let heightOptions = [28, 30, 32, 34, 36, 38, 40]

    var body: some View {
        VStack(spacing: 14) {
            DimensionRow(
                label: "Ancho",
                unit: "\"",
                options: widthOptions,
                selected: dimensions.widthInches,
                onSelect: { dimensions.widthInches = $0 }
            )
            DimensionRow(
                label: "Fondo",
                unit: "\"",
                options: depthOptions,
                selected: dimensions.depthInches,
                onSelect: { dimensions.depthInches = $0 }
            )
            DimensionRow(
                label: "Altura",
                unit: "\"",
                options: heightOptions,
                selected: dimensions.heightInches,
                onSelect: { dimensions.heightInches = $0 }
            )

            Text("\(dimensions.widthInches)\" × \(dimensions.depthInches)\" × \(dimensions.heightInches)\"")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

private struct DimensionRow: View {
    let label: String
    let unit: String
    let options: [Int]
    let selected: Int
    let onSelect: (Int) -> Void

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .frame(width: 60, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(options, id: \.self) { val in
                        Button {
                            onSelect(val)
                        } label: {
                            Text("\(val)\(unit)")
                                .font(.caption.weight(.medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(selected == val ? Color.accentColor : Color(.tertiarySystemBackground))
                                .foregroundStyle(selected == val ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
