import Foundation

final class MaterialsService {
    static let shared = MaterialsService()
    private init() {}

    func fetchMaterials(showTopColors: Bool = true) async throws -> [Material] {
        let items: [URLQueryItem] = showTopColors
            ? [URLQueryItem(name: "show_top_colors", value: "1")]
            : []
        let response: APIListResponse<Material> = try await APIClient.shared.get(
            path: "/api/materials",
            queryItems: items
        )
        return response.data ?? []
    }

    func fetchTopColors() async throws -> [ColorOption] {
        let response: APIListResponse<ColorOption> = try await APIClient.shared.get(
            path: "/api/colors",
            queryItems: [
                URLQueryItem(name: "type", value: "top"),
                URLQueryItem(name: "active", value: "1")
            ]
        )
        return response.data ?? []
    }

    func fetchFrameColors() async throws -> [ColorOption] {
        let response: APIListResponse<ColorOption> = try await APIClient.shared.get(
            path: "/api/colors",
            queryItems: [
                URLQueryItem(name: "type", value: "frame"),
                URLQueryItem(name: "active", value: "1")
            ]
        )
        return response.data ?? []
    }
}
