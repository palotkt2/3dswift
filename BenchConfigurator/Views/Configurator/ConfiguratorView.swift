import SwiftUI

struct ConfiguratorView: View {
    @EnvironmentObject var vm: ConfiguratorViewModel

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading && vm.allSeries.isEmpty {
                    ProgressView("Cargando configurador…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            // 3D Viewer placeholder
                            ModelViewerPlaceholder(configuration: vm.configuration)
                                .frame(height: 260)

                            VStack(spacing: 16) {
                                // Series
                                SectionCard(title: "Serie") {
                                    SeriesSelectorView(
                                        series: vm.allSeries,
                                        selected: vm.configuration.series,
                                        onSelect: { vm.selectSeries($0) }
                                    )
                                }

                                // Dimensions
                                SectionCard(title: "Dimensiones") {
                                    DimensionsView(
                                        dimensions: $vm.configuration.dimensions
                                    )
                                }

                                // Material
                                SectionCard(title: "Material de superficie") {
                                    MaterialPickerView(
                                        materials: vm.allMaterials,
                                        selected: vm.configuration.material,
                                        onSelect: { vm.selectMaterial($0) }
                                    )
                                }

                                // Top color
                                if vm.configuration.material?.showTopColors == true {
                                    SectionCard(title: "Color de superficie") {
                                        ColorSwatchGridView(
                                            colors: vm.topColors,
                                            selected: vm.configuration.topColor,
                                            onSelect: { vm.selectTopColor($0) }
                                        )
                                    }
                                }

                                // Frame color
                                if vm.configuration.material?.showFrameColors == true {
                                    SectionCard(title: "Color de estructura") {
                                        ColorSwatchGridView(
                                            colors: vm.frameColors,
                                            selected: vm.configuration.frameColor,
                                            onSelect: { vm.selectFrameColor($0) }
                                        )
                                    }
                                }

                                // Accessories
                                SectionCard(title: "Accesorios") {
                                    AccessoriesView(
                                        accessories: vm.accessories,
                                        selected: $vm.configuration.accessories
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Configurador")
            .navigationBarTitleDisplayMode(.large)
            .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
                Button("OK") { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
    }
}
