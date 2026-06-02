import Foundation

final class AccessoriesService {
    static let shared = AccessoriesService()
    private init() {}

    func fetchCategories() async throws -> [AccessoryCategory] {
        let response: APIListResponse<AccessoryCategory> = try await APIClient.shared.get(
            path: "/api/accessories/categories"
        )
        return response.data ?? []
    }

    func fetchAccessories(series: String, category: String? = nil) async throws -> [AccessoryParent] {
        var queryItems = [URLQueryItem(name: "series", value: series)]
        if let category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        let response: APIListResponse<AccessoryParent> = try await APIClient.shared.get(
            path: "/api/accessories",
            queryItems: queryItems
        )
        return response.data ?? []
    }
}
