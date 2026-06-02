# BenchConfigurator — iOS App

App nativa iOS (SwiftUI) para el configurador 3D industrial.
Consume las mismas APIs REST del backend Next.js existente.

---

## Requisitos

| Tool               | Versión mínima                             |
| ------------------ | ------------------------------------------ |
| Xcode              | 15+                                        |
| iOS target         | 17.0+                                      |
| macOS (desarrollo) | 14+ (Sonoma)                               |
| Backend Next.js    | corriendo en `localhost:3000` o producción |

---

## Estructura del proyecto

```
ios-app/
├── Package.swift                  # Referencia de estructura
└── BenchConfigurator/
    ├── App/
    │   └── BenchConfiguratorApp.swift  # @main entry point
    ├── Config/
    │   └── AppConfig.swift             # Base URL, company slug
    ├── Models/                          # Structs Codable (espejo de los tipos TS)
    │   ├── Series.swift
    │   ├── Material.swift               # + ColorOption + Color(hex:)
    │   ├── DimensionPreset.swift
    │   ├── Accessory.swift
    │   └── Configuration.swift          # BenchConfiguration, QuoteRequest, etc.
    ├── Networking/
    │   └── APIClient.swift              # URLSession async/await genérico
    ├── Services/                        # Un servicio por dominio API
    │   ├── SeriesService.swift
    │   ├── MaterialsService.swift
    │   ├── AccessoriesService.swift
    │   ├── BuilderOptionsService.swift
    │   └── QuoteService.swift
    ├── ViewModels/
    │   ├── ConfiguratorViewModel.swift  # @MainActor ObservableObject
    │   └── QuoteViewModel.swift
    └── Views/
        ├── ContentView.swift            # TabView raíz
        ├── Configurator/
        │   ├── ConfiguratorView.swift
        │   ├── SeriesSelectorView.swift
        │   ├── DimensionsView.swift
        │   ├── MaterialPickerView.swift
        │   ├── ColorSwatchGridView.swift
        │   └── AccessoriesView.swift
        ├── Quote/
        │   └── QuoteFormView.swift
        ├── Viewer3D/
        │   └── ModelViewerPlaceholder.swift  # Swap por RealityKit cuando tengas USDZ
        └── Components/
            └── SectionCard.swift
```

---

## Setup en Xcode

### Opción A — Nuevo proyecto (recomendado)

1. Abre Xcode → **File → New → Project**
2. Elige **App** (iOS)
3. Nombre: `BenchConfigurator`, Interface: **SwiftUI**, Language: **Swift**
4. Guarda en `ios-app/`
5. Arrastra la carpeta `BenchConfigurator/` (con todos los `.swift`) al navigator de Xcode
6. Asegúrate de que todos los archivos tienen **Target Membership** activado

### Opción B — Swift Package App (Xcode 15+)

1. `File → Open` → selecciona `ios-app/Package.swift`
2. Xcode abre el paquete; ajusta el scheme a iOS Simulator

---

## Configuración del backend

En Xcode, edita **Info.plist** y agrega:

```xml
<key>API_BASE_URL</key>
<string>https://tu-servidor.com</string>
<key>COMPANY_SLUG</key>
<string>default</string>
```

O modifica `AppConfig.swift` directamente con tu URL.

### Permisos de red (ATS)

Si el servidor corre en HTTP (no HTTPS), agrega en `Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

## Visor 3D — Roadmap

El archivo `ModelViewerPlaceholder.swift` muestra un placeholder.
Para activar el visor 3D real:

1. **Convertir GLB → USDZ**:
   ```bash
   # Instala Reality Converter (gratis en Mac App Store) o usa la CLI:
   xcrun usdz_converter modelo.glb modelo.usdz
   ```
2. Agrega los `.usdz` al bundle de Xcode (en `Assets.xcassets` o carpeta `Models/`)
3. En `ModelViewerPlaceholder.swift`, descomenta el bloque `SceneKit` (o usa `RealityView` para AR)

```swift
// RealityKit (iOS 18+)
import RealityKit
RealityView { content in
    if let model = try? await ModelEntity(named: "bench-kennedy") {
        content.add(model)
    }
}

// SceneKit (iOS 13+)
SceneView(scene: SCNScene(named: "bench-kennedy.usdz"), options: [.allowsCameraControl, .autoenablesDefaultLighting])
```

---

## APIs consumidas

| Endpoint                                     | Servicio                |
| -------------------------------------------- | ----------------------- |
| `GET /api/series`                            | `SeriesService`         |
| `GET /api/materials`                         | `MaterialsService`      |
| `GET /api/colors?type=top`                   | `MaterialsService`      |
| `GET /api/colors?type=frame`                 | `MaterialsService`      |
| `GET /api/accessories?series=<slug>`         | `AccessoriesService`    |
| `GET /api/accessories/categories`            | `AccessoriesService`    |
| `GET /api/product-builder/thickness-options` | `BuilderOptionsService` |
| `GET /api/product-builder/hydraulic-options` | `BuilderOptionsService` |
| `GET /api/product-builder/finish-options`    | `BuilderOptionsService` |
| `GET /api/product-builder/edge-designs`      | `BuilderOptionsService` |
| `GET /api/product-builder/quote-number`      | `QuoteService`          |
| `POST /api/request-quote`                    | `QuoteService`          |
