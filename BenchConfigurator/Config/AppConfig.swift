import Foundation

enum AppConfig {
    // MARK: - Base URL — change to your production or dev server
    static var baseURL: String {
        // Read from Info.plist key "API_BASE_URL" if present, otherwise use default
        if let url = Bundle.main.infoDictionary?["API_BASE_URL"] as? String, !url.isEmpty {
            return url
        }
        return "http://localhost:3000"
    }

    static var apiBaseURL: URL {
        URL(string: baseURL)!
    }

    // MARK: - Company slug (multi-tenant support)
    static var companySlug: String {
        Bundle.main.infoDictionary?["COMPANY_SLUG"] as? String ?? "default"
    }

    // MARK: - Timeouts
    static let requestTimeout: TimeInterval = 30
    static let resourceTimeout: TimeInterval = 60
}
