import SwiftUI

struct QuoteFormView: View {
    @EnvironmentObject var configuratorVM: ConfiguratorViewModel
    @EnvironmentObject var quoteVM: QuoteViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Tu información") {
                    TextField("Nombre completo *", text: $quoteVM.customerName)
                        .textContentType(.name)
                        .autocorrectionDisabled()

                    TextField("Correo electrónico *", text: $quoteVM.customerEmail)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()

                    TextField("Teléfono (opcional)", text: $quoteVM.customerPhone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }

                Section("Configuración seleccionada") {
                    ConfigSummaryRow(label: "Serie", value: configuratorVM.configuration.series?.name)
                    ConfigSummaryRow(label: "Material", value: configuratorVM.configuration.material?.displayName)
                    ConfigSummaryRow(label: "Dimensiones", value: configuratorVM.configuration.dimensions.displayLabel)
                    if let color = configuratorVM.configuration.topColor {
                        ConfigSummaryRow(label: "Color superficie", value: color.name, hex: color.hexValue)
                    }
                    if let frame = configuratorVM.configuration.frameColor {
                        ConfigSummaryRow(label: "Color estructura", value: frame.name, hex: frame.hexValue)
                    }
                }

                Section("Comentarios") {
                    TextEditor(text: $quoteVM.message)
                        .frame(minHeight: 80)
                }

                if !quoteVM.nextQuoteNumber.isEmpty {
                    Section {
                        HStack {
                            Text("N° de cotización")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(quoteVM.nextQuoteNumber)
                                .fontDesign(.monospaced)
                                .fontWeight(.medium)
                        }
                    }
                }

                Section {
                    Button {
                        Task {
                            await quoteVM.submitQuote(
                                configuration: configuratorVM.configuration
                            )
                        }
                    } label: {
                        if quoteVM.submissionState == .loading {
                            HStack {
                                ProgressView()
                                Text("Enviando…")
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Text("Enviar solicitud de cotización")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(!quoteVM.isFormValid || quoteVM.submissionState == .loading)
                }
            }
            .navigationTitle("Cotización")
            .navigationBarTitleDisplayMode(.large)
            .task { await quoteVM.loadNextNumber() }
            .alert(successTitle, isPresented: .constant(isSuccess)) {
                Button("Cerrar") { quoteVM.reset() }
            } message: {
                Text(successMessage)
            }
            .alert("Error al enviar", isPresented: .constant(isFailure)) {
                Button("OK") { quoteVM.submissionState = .idle }
            } message: {
                if case .failure(let msg) = quoteVM.submissionState {
                    Text(msg)
                }
            }
        }
    }

    private var isSuccess: Bool {
        if case .success = quoteVM.submissionState { return true }
        return false
    }

    private var isFailure: Bool {
        if case .failure = quoteVM.submissionState { return true }
        return false
    }

    private var successTitle: String { "¡Cotización enviada!" }

    private var successMessage: String {
        if case .success(let num) = quoteVM.submissionState {
            return "Tu cotización \(num) ha sido enviada. Revisa tu correo electrónico."
        }
        return "Tu cotización ha sido enviada."
    }
}

private struct ConfigSummaryRow: View {
    let label: String
    let value: String?
    var hex: String? = nil

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            if let hex {
                Circle()
                    .fill(Color(hex: hex) ?? .gray)
                    .frame(width: 14, height: 14)
                    .overlay(Circle().strokeBorder(Color(.separator), lineWidth: 0.5))
            }
            Text(value ?? "—")
                .fontWeight(.medium)
        }
    }
}

extension CustomDimensions {
    var displayLabel: String {
        "\(widthInches)\" × \(depthInches)\" × \(heightInches)\""
    }
}
