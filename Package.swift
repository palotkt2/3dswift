// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BenchConfigurator",
    platforms: [
        .iOS(.v17)
    ],
    targets: [
        .executableTarget(
            name: "BenchConfigurator",
            path: "BenchConfigurator"
        )
    ]
)
