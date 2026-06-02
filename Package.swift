// swift-tools-version: 5.9
// Este Package.swift es solo referencia de estructura.
// El proyecto real se abre como App en Xcode (no como SwiftPM library).
// Ver README.md para instrucciones de setup.

import PackageDescription

let package = Package(
    name: "BenchConfigurator",
    platforms: [.iOS(.v17)],
    targets: [
        .target(
            name: "BenchConfigurator",
            path: "BenchConfigurator",
            resources: [.process("Assets.xcassets")]
        )
    ]
)
