import Foundation

final class BuilderOptionsService {
    static let shared = BuilderOptionsService()
    private init() {}

    func fetchThicknessOptions(parentId: Int, materialId: Int? = nil) async throws -> [ThicknessOption] {
        var items = [URLQueryItem(name: "parent_id", value: "\(parentId)")]
        if let materialId { items.append(URLQueryItem(name: "material_id", value: "\(materialId)")) }
        let response: APIListResponse<ThicknessOption> = try await APIClient.shared.get(
            path: "/api/product-builder/thickness-options",
            queryItems: items
        )
        return response.data ?? []
    }

    func fetchHydraulicOptions(parentId: Int) async throws -> [HydraulicOption] {
        let response: APIListResponse<HydraulicOption> = try await APIClient.shared.get(
            path: "/api/product-builder/hydraulic-options",
            queryItems: [URLQueryItem(name: "parent_id", value: "\(parentId)")]
        )
        return response.data ?? []
    }

    func fetchFinishOptions(parentId: Int) async throws -> [FinishOption] {
        let response: APIListResponse<FinishOption> = try await APIClient.shared.get(
            path: "/api/product-builder/finish-options",
            queryItems: [URLQueryItem(name: "parent_id", value: "\(parentId)")]
        )
        return response.data ?? []
    }

    func fetchEdgeDesigns(parentId: Int, materialId: Int? = nil) async throws -> [EdgeDesign] {
        var items = [URLQueryItem(name: "parent_id", value: "\(parentId)")]
        if let materialId { items.append(URLQueryItem(name: "material_id", value: "\(materialId)")) }
        let response: APIListResponse<EdgeDesign> = try await APIClient.shared.get(
            path: "/api/product-builder/edge-designs",
            queryItems: items
        )
        return response.data ?? []
    }
}
