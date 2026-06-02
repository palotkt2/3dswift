import Foundation

// MARK: - API Errors
enum APIError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int, String?)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL inválida."
        case .noData: return "El servidor no devolvió datos."
        case .decodingError(let e): return "Error al procesar respuesta: \(e.localizedDescription)"
        case .serverError(let code, let msg): return "Error del servidor (\(code)): \(msg ?? "Sin mensaje")"
        case .networkError(let e): return "Error de red: \(e.localizedDescription)"
        }
    }
}

// MARK: - Generic API response wrapper
struct APIListResponse<T: Decodable>: Decodable {
    let data: [T]?
    let success: Bool?
    let message: String?
}

struct APIObjectResponse<T: Decodable>: Decodable {
    let data: T?
    let success: Bool?
    let message: String?
}

// MARK: - HTTP Client
final class APIClient {
    static let shared = APIClient()

    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = AppConfig.requestTimeout
        config.timeoutIntervalForResource = AppConfig.resourceTimeout
        session = URLSession(configuration: config)
    }

    // MARK: - GET
    func get<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem] = []
    ) async throws -> T {
        var components = URLComponents(url: AppConfig.apiBaseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        guard let url = components?.url else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return try await perform(request)
    }

    // MARK: - POST
    func post<Body: Encodable, T: Decodable>(
        path: String,
        body: Body
    ) async throws -> T {
        guard let url = URL(string: path, relativeTo: AppConfig.apiBaseURL) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(body)
        return try await perform(request)
    }

    // MARK: - Core
    private func perform<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8)
            throw APIError.serverError(http.statusCode, body)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
