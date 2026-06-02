import Foundation
import Combine

@MainActor
final class ConfiguratorViewModel: ObservableObject {
    // MARK: - Published state
    @Published var allSeries: [Series] = []
    @Published var allMaterials: [Material] = []
    @Published var topColors: [ColorOption] = []
    @Published var frameColors: [ColorOption] = []
    @Published var accessories: [AccessoryParent] = []

    @Published var configuration = BenchConfiguration()

    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Load all baseline data
    func loadInitialData() async {
        isLoading = true
        errorMessage = nil
        do {
            async let seriesFetch = SeriesService.shared.fetchAll()
            async let materialsFetch = MaterialsService.shared.fetchMaterials()
            async let topColorsFetch = MaterialsService.shared.fetchTopColors()
            async let frameColorsFetch = MaterialsService.shared.fetchFrameColors()

            let (series, materials, topColors, frameColors) = try await (
                seriesFetch, materialsFetch, topColorsFetch, frameColorsFetch
            )

            self.allSeries = series
            self.allMaterials = materials
            self.topColors = topColors
            self.frameColors = frameColors

            // Auto-select defaults
            if configuration.series == nil {
                configuration.series = series.first(where: { $0.isDefault }) ?? series.first
            }
            if configuration.material == nil {
                configuration.material = materials.first
            }

            if let series = configuration.series {
                await loadAccessories(for: series.slug)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func loadAccessories(for seriesSlug: String) async {
        do {
            accessories = try await AccessoriesService.shared.fetchAccessories(series: seriesSlug)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Setters that trigger side effects
    func selectSeries(_ series: Series) {
        configuration.series = series
        configuration.accessories = SelectedAccessories()
        Task { await loadAccessories(for: series.slug) }
    }

    func selectMaterial(_ material: Material) {
        configuration.material = material
        if !material.showTopColors { configuration.topColor = nil }
        if !material.showFrameColors { configuration.frameColor = nil }
    }

    func selectTopColor(_ color: ColorOption) {
        configuration.topColor = color
    }

    func selectFrameColor(_ color: ColorOption) {
        configuration.frameColor = color
    }

    func updateDimensions(_ dims: CustomDimensions) {
        configuration.dimensions = dims
    }

    func updateAccessories(_ acc: SelectedAccessories) {
        configuration.accessories = acc
    }
}
