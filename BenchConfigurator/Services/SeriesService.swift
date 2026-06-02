import Foundation

final class SeriesService {
    static let shared = SeriesService()
    private init() {}

    func fetchAll() async throws -> [Series] {
        let response: APIListResponse<Series> = try await APIClient.shared.get(path: "/api/series")
        return response.data ?? []
    }
}
