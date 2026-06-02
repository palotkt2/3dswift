import SwiftUI

struct AccessoriesView: View {
    let accessories: [AccessoryParent]
    @Binding var selected: SelectedAccessories

    var body: some View {
        if accessories.isEmpty {
            Text("No hay accesorios disponibles para esta serie.")
                .font(.caption)
                .foregroundStyle(.secondary)
        } else {
            VStack(spacing: 10) {
                // Group by category
                let byCategory = Dictionary(grouping: accessories, by: { $0.category ?? "General" })
                ForEach(byCategory.keys.sorted(), id: \.self) { category in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(category)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)

                        ForEach(byCategory[category] ?? []) { acc in
                            AccessoryToggleRow(
                                accessory: acc,
                                isOn: binding(for: acc)
                            )
                        }
                    }
                }
            }
        }
    }

    // Map accessory SKU/name to the correct toggle binding
    private func binding(for acc: AccessoryParent) -> Binding<Bool> {
        let name = acc.name.lowercased()
        if name.contains("cabinet") { return $selected.showCabinet }
        if name.contains("top shelf") { return $selected.showTopShelf }
        if name.contains("bottom shelf") { return $selected.showBottomShelf }
        if name.contains("wire shelf") { return $selected.showWireShelf }
        if name.contains("bin box") { return $selected.showBinBoxRail }
        if name.contains("usb") { return $selected.showUSBPort }
        if name.contains("plug") || name.contains("power strip") { return $selected.showPlug }
        if name.contains("upright") { return $selected.showUprights }
        if name.contains("cpu") { return $selected.showCPUHolder }
        if name.contains("keyboard") { return $selected.showKeyboardTray }
        if name.contains("monitor") { return $selected.showMonitorHolder }
        if name.contains("led") && name.contains("overhead") { return $selected.showOverheadLEDLight }
        if name.contains("undershelf") { return $selected.showUndershelfLED }
        if name.contains("led") { return $selected.showLEDLight }
        if name.contains("in-frame") || name.contains("inframe") { return $selected.showInFramePower }
        // Fallback — read-only false
        return .constant(false)
    }
}

private struct AccessoryToggleRow: View {
    let accessory: AccessoryParent
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: 8) {
                if let imageUrl = accessory.imageUrl {
                    AsyncImage(url: URL(string: AppConfig.baseURL + imageUrl)) { img in
                        img.resizable().scaledToFit()
                    } placeholder: {
                        Image(systemName: "shippingbox")
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: 28, height: 28)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(accessory.name)
                        .font(.subheadline)
                    if let price = accessory.basePrice {
                        Text(price, format: .currency(code: "USD"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .tint(.accentColor)
    }
}
