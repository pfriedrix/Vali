// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Valiloc",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "Valiloc",
            targets: ["Valiloc"]),
        .executable(name: "DemoApp", targets: ["App"])
    ],
    targets: [
        .target(
            name: "Valiloc",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ValilocTests",
            dependencies: ["Valiloc"]
        ),
        .executableTarget(name: "App", 
                          dependencies: ["Valiloc"])
    ]
)
