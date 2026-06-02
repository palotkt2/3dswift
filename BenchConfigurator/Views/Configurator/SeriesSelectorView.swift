import SwiftUI

struct SeriesSelectorView: View {
    let series: [Series]
    let selected: Series?
    let onSelect: (Series) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(series) { s in
                    SeriesChip(
                        title: s.name,
                        isSelected: selected?.id == s.id,
                        action: { onSelect(s) }
                    )
                }
            }
            .padding(.horizontal, 2)
        }
    }
}

private struct SeriesChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(isSelected ? Color.accentColor : Color(.separator), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
