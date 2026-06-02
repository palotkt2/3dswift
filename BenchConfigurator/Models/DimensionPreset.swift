import Foundation

struct DimensionPreset: Codable, Identifiable, Hashable {
    let id: Int
    let name: String?
    let category: String?
    let widthInches: Int
    let depthInches: Int
    let heightInches: Int
    let widthCm: Double?
    let depthCm: Double?
    let heightCm: Double?
    let isDefault: Bool?
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, category
        case widthInches = "width_inches"
        case depthInches = "depth_inches"
        case heightInches = "height_inches"
        case widthCm = "width_cm"
        case depthCm = "depth_cm"
        case heightCm = "height_cm"
        case isDefault = "is_default"
        case isActive = "is_active"
    }

    var displayLabel: String {
        "\(widthInches)\" × \(depthInches)\" × \(heightInches)\""
    }
}

struct CustomDimensions: Equatable {
    var widthInches: Int
    var depthInches: Int
    var heightInches: Int

    static let defaults = CustomDimensions(widthInches: 60, depthInches: 30, heightInches: 34)
}
