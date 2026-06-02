import Foundation

// MARK: - Builder options
struct ThicknessOption: Codable, Identifiable, Hashable {
    let id: Int
    let code: String
    let name: String
    let skuSuffix: String?
    let priceDelta: Double?

    enum CodingKeys: String, CodingKey {
        case id, code, name
        case skuSuffix = "sku_suffix"
        case priceDelta = "price_delta"
    }
}

struct HydraulicOption: Codable, Identifiable, Hashable {
    let id: Int
    let code: String
    let name: String
    let skuSuffix: String?
    let priceDelta: Double?

    enum CodingKeys: String, CodingKey {
        case id, code, name
        case skuSuffix = "sku_suffix"
        case priceDelta = "price_delta"
    }
}

struct FinishOption: Codable, Identifiable, Hashable {
    let id: Int
    let code: String
    let name: String
    let skuSuffix: String?
    let priceDelta: Double?

    enum CodingKeys: String, CodingKey {
        case id, code, name
        case skuSuffix = "sku_suffix"
        case priceDelta = "price_delta"
    }
}

struct EdgeDesign: Codable, Identifiable, Hashable {
    let id: Int
    let code: String
    let name: String
    let description: String?
    let priceDelta: Double?

    enum CodingKeys: String, CodingKey {
        case id, code, name, description
        case priceDelta = "price_delta"
    }
}

// MARK: - Full configuration state
struct BenchConfiguration: Equatable {
    var series: Series?
    var material: Material?
    var topColor: ColorOption?
    var frameColor: ColorOption?
    var dimensions: CustomDimensions = .defaults
    var accessories: SelectedAccessories = SelectedAccessories()
    var thicknessOption: ThicknessOption?
    var hydraulicOption: HydraulicOption?
    var finishOption: FinishOption?
    var edgeDesign: EdgeDesign?

    var isComplete: Bool {
        series != nil && material != nil
    }
}

// MARK: - Quote models
struct QuoteRequest: Encodable {
    let customerName: String
    let customerEmail: String
    let customerPhone: String?
    let message: String?
    let screenshotBase64: String?
    let config: QuoteConfig

    struct QuoteConfig: Encodable {
        let tableLength: Int
        let tableDepth: Int
        let tableHeight: Int
        let surface: String
        let tableTopColor: String?
        let frameColor: String?
        let series: String?
        let thicknessOption: OptionRef?
        let hydraulicOption: OptionRef?
        let finishOption: OptionRef?
        let edgeDesign: OptionRef?
        let accessories: [String: AnyCodable]

        struct OptionRef: Encodable {
            let code: String
            let name: String
        }
    }
}

struct QuoteResponse: Decodable {
    let success: Bool
    let quoteNumber: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case success, message
        case quoteNumber = "quoteNumber"
    }
}

// MARK: - AnyCodable helper for accessories dict
struct AnyCodable: Encodable {
    private let encode: (Encoder) throws -> Void

    init<T: Encodable>(_ value: T) {
        encode = { encoder in try value.encode(to: encoder) }
    }

    func encode(to encoder: Encoder) throws {
        try encode(encoder)
    }
}
