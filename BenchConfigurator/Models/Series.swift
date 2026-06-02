import Foundation

struct Series: Codable, Identifiable, Hashable {
    let id: Int
    let slug: String
    let name: String
    let description: String?
    let modelPath: String
    let modelPathAlt: String?
    let hasHydraulicVariant: Bool
    let hydraulicElectricModel: String?
    let hydraulicManualModel: String?
    let sortOrder: Int?
    let isActive: Bool
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id, slug, name, description
        case modelPath = "model_path"
        case modelPathAlt = "model_path_alt"
        case hasHydraulicVariant = "has_hydraulic_variant"
        case hydraulicElectricModel = "hydraulic_electric_model"
        case hydraulicManualModel = "hydraulic_manual_model"
        case sortOrder = "sort_order"
        case isActive = "is_active"
        case isDefault = "is_default"
    }
}
