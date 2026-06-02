import Foundation
import SwiftUI

struct Material: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let displayName: String
    let materialType: String
    let texturePath: String?
    let normalMapPath: String?
    let roughnessMapPath: String?
    let roughness: Double?
    let metalness: Double?
    let showTopColors: Bool
    let showFrameColors: Bool
    let disableColorOverlay: Bool
    let sortOrder: Int?
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id, name
        case displayName = "display_name"
        case materialType = "material_type"
        case texturePath = "texture_path"
        case normalMapPath = "normal_map_path"
        case roughnessMapPath = "roughness_map_path"
        case roughness, metalness
        case showTopColors = "show_top_colors"
        case showFrameColors = "show_frame_colors"
        case disableColorOverlay = "disable_color_overlay"
        case sortOrder = "sort_order"
        case isActive = "is_active"
    }
}

struct ColorOption: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let displayName: String?
    let hexValue: String
    let colorType: String
    let sortOrder: Int?
    let isActive: Bool

    enum CodingKeys: String, CodingKey {
        case id, name
        case displayName = "display_name"
        case hexValue = "hex_value"
        case colorType = "color_type"
        case sortOrder = "sort_order"
        case isActive = "is_active"
    }

    var color: Color {
        Color(hex: hexValue) ?? .gray
    }
}

// MARK: - Color extension for hex parsing
extension Color {
    init?(hex: String) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleaned = cleaned.hasPrefix("#") ? String(cleaned.dropFirst()) : cleaned
        guard cleaned.count == 6 || cleaned.count == 8 else { return nil }
        let scanner = Scanner(string: cleaned)
        var rgb: UInt64 = 0
        guard scanner.scanHexInt64(&rgb) else { return nil }
        if cleaned.count == 6 {
            self = Color(
                red: Double((rgb >> 16) & 0xFF) / 255,
                green: Double((rgb >> 8) & 0xFF) / 255,
                blue: Double(rgb & 0xFF) / 255
            )
        } else {
            self = Color(
                red: Double((rgb >> 24) & 0xFF) / 255,
                green: Double((rgb >> 16) & 0xFF) / 255,
                blue: Double((rgb >> 8) & 0xFF) / 255,
                opacity: Double(rgb & 0xFF) / 255
            )
        }
    }
}
