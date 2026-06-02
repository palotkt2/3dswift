import Foundation

enum QuoteSubmissionState: Equatable {
    case idle
    case loading
    case success(quoteNumber: String)
    case failure(String)
}

@MainActor
final class QuoteViewModel: ObservableObject {
    @Published var customerName: String = ""
    @Published var customerEmail: String = ""
    @Published var customerPhone: String = ""
    @Published var message: String = ""
    @Published var submissionState: QuoteSubmissionState = .idle
    @Published var nextQuoteNumber: String = ""

    func loadNextNumber() async {
        do {
            nextQuoteNumber = try await QuoteService.shared.previewNextNumber()
        } catch {
            nextQuoteNumber = ""
        }
    }

    var isFormValid: Bool {
        !customerName.trimmingCharacters(in: .whitespaces).isEmpty &&
        isValidEmail(customerEmail)
    }

    func submitQuote(configuration: BenchConfiguration, screenshotBase64: String? = nil) async {
        guard isFormValid else { return }
        submissionState = .loading
        let request = QuoteService.shared.buildRequest(
            config: configuration,
            customerName: customerName.trimmingCharacters(in: .whitespaces),
            customerEmail: customerEmail.trimmingCharacters(in: .whitespaces),
            customerPhone: customerPhone,
            message: message,
            screenshotBase64: screenshotBase64
        )
        do {
            let response = try await QuoteService.shared.submitQuote(request)
            submissionState = .success(quoteNumber: response.quoteNumber ?? nextQuoteNumber)
        } catch {
            submissionState = .failure(error.localizedDescription)
        }
    }

    func reset() {
        customerName = ""
        customerEmail = ""
        customerPhone = ""
        message = ""
        submissionState = .idle
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
