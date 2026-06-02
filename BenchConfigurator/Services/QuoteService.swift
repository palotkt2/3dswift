import Foundation

final class QuoteService {
    static let shared = QuoteService()
    private init() {}

    func previewNextNumber() async throws -> String {
        struct Preview: Decodable { let preview: String? }
        let result: Preview = try await APIClient.shared.get(path: "/api/product-builder/quote-number")
        return result.preview ?? "3DQ-XXXXX"
    }

    func submitQuote(_ request: QuoteRequest) async throws -> QuoteResponse {
        try await APIClient.shared.post(path: "/api/request-quote", body: request)
    }

    // MARK: - Build QuoteRequest from BenchConfiguration
    func buildRequest(
        config: BenchConfiguration,
        customerName: String,
        customerEmail: String,
        customerPhone: String?,
        message: String?,
        screenshotBase64: String? = nil
    ) -> QuoteRequest {
        var accessoriesDict: [String: AnyCodable] = [:]
        let acc = config.accessories
        if acc.showCabinet        { accessoriesDict["showCabinet"] = AnyCodable(true) }
        if acc.showTopShelf       { accessoriesDict["showTopShelf"] = AnyCodable(true) }
        if acc.showBottomShelf    { accessoriesDict["showBottomShelf"] = AnyCodable(true) }
        if acc.showWireShelf      { accessoriesDict["showWireShelf"] = AnyCodable(true) }
        if acc.showBinBoxRail     { accessoriesDict["showBinBoxRail"] = AnyCodable(true) }
        if acc.showPlug           { accessoriesDict["showPlug"] = AnyCodable(true) }
        if acc.showUSBPort        { accessoriesDict["showUSBPort"] = AnyCodable(true) }
        if acc.showUprights       { accessoriesDict["showUprights"] = AnyCodable(true) }
        if let h = acc.uprightHeight { accessoriesDict["uprightHeight"] = AnyCodable(h) }
        if acc.showCPUHolder      { accessoriesDict["showCPUHolder"] = AnyCodable(true) }
        if acc.showKeyboardTray   { accessoriesDict["showKeyboardTray"] = AnyCodable(true) }
        if acc.showMonitorHolder  { accessoriesDict["showMonitorHolder"] = AnyCodable(true) }
        if acc.showLEDLight       { accessoriesDict["showLEDLight"] = AnyCodable(true) }
        if acc.showOverheadLEDLight { accessoriesDict["showOverheadLEDLight"] = AnyCodable(true) }
        if acc.showUndershelfLED  { accessoriesDict["showUndershelfLED"] = AnyCodable(true) }
        if acc.showInFramePower   { accessoriesDict["showInFramePower"] = AnyCodable(true) }
        if let legs = acc.adjustableLegs { accessoriesDict["adjustableLegs"] = AnyCodable(legs) }
        if let drawer = acc.drawerType   { accessoriesDict["drawerType"] = AnyCodable(drawer) }

        let quoteConfig = QuoteRequest.QuoteConfig(
            tableLength: config.dimensions.widthInches,
            tableDepth: config.dimensions.depthInches,
            tableHeight: config.dimensions.heightInches,
            surface: config.material?.name ?? "",
            tableTopColor: config.topColor?.hexValue,
            frameColor: config.frameColor?.hexValue,
            series: config.series?.slug,
            thicknessOption: config.thicknessOption.map { .init(code: $0.code, name: $0.name) },
            hydraulicOption: config.hydraulicOption.map { .init(code: $0.code, name: $0.name) },
            finishOption: config.finishOption.map { .init(code: $0.code, name: $0.name) },
            edgeDesign: config.edgeDesign.map { .init(code: $0.code, name: $0.name) },
            accessories: accessoriesDict
        )

        return QuoteRequest(
            customerName: customerName,
            customerEmail: customerEmail,
            customerPhone: customerPhone?.isEmpty == true ? nil : customerPhone,
            message: message?.isEmpty == true ? nil : message,
            screenshotBase64: screenshotBase64,
            config: quoteConfig
        )
    }
}
