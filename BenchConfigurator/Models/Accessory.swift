import Foundation

struct AccessoryCategory: Codable, Identifiable, Hashable {
    let id: Int
    let slug: String
    let name: String
    let icon: String?
    let sortOrder: Int?

    enum CodingKeys: String, CodingKey {
        case id, slug, name, icon
        case sortOrder = "sort_order"
    }
}

struct AccessoryVariant: Codable, Identifiable, Hashable {
    let id: Int
    let sku: String
    let partNumber: String?
    let label: String
    let basePrice: Double?
    let weightLbs: Double?
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id, sku, label
        case partNumber = "part_number"
        case basePrice = "base_price"
        case weightLbs = "weight_lbs"
        case isActive = "is_active"
    }
}

struct AccessoryParent: Codable, Identifiable, Hashable {
    let id: Int
    let sku: String
    let name: String
    let description: String?
    let category: String?
    let imageUrl: String?
    let basePrice: Double?
    let isConfigurable: Bool
    let sortOrder: Int?
    let isActive: Bool
    let variants: [AccessoryVariant]

    enum CodingKeys: String, CodingKey {
        case id, sku, name, description, category, variants
        case imageUrl = "image_url"
        case basePrice = "base_price"
        case isConfigurable = "is_configurable"
        case sortOrder = "sort_order"
        case isActive = "is_active"
    }
}

// MARK: - Selected accessories state model
struct SelectedAccessories: Equatable {
    var showCabinet: Bool = false
    var showTopShelf: Bool = false
    var showBottomShelf: Bool = false
    var showWireShelf: Bool = false
    var showBinBoxRail: Bool = false
    var showPlug: Bool = false
    var showUSBPort: Bool = false
    var showUprights: Bool = false
    var uprightHeight: Int? = nil
    var showCPUHolder: Bool = false
    var showKeyboardTray: Bool = false
    var showMonitorHolder: Bool = false
    var showLEDLight: Bool = false
    var showOverheadLEDLight: Bool = false
    var showUndershelfLED: Bool = false
    var showInFramePower: Bool = false
    var adjustableLegs: String? = nil
    var drawerType: String? = nil
}
