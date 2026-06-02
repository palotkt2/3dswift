import SwiftUI

struct ColorSwatchGridView: View {
    let colors: [ColorOption]
    let selected: ColorOption?
    let onSelect: (ColorOption) -> Void

    private let columns = [GridItem(.adaptive(minimum: 44), spacing: 8)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(colors) { colorOpt in
                ColorSwatch(
                    colorOption: colorOpt,
                    isSelected: selected?.id == colorOpt.id,
                    action: { onSelect(colorOpt) }
                )
            }
        }
    }
}

struct ColorSwatch: View {
    let colorOption: ColorOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(colorOption.color)
                .frame(width: 36, height: 36)
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? Color.accentColor : Color(.separator), lineWidth: isSelected ? 3 : 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(colorOption.displayName ?? colorOption.name)
    }
}
