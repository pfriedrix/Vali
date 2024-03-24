// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Valiloc",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Valiloc",
            targets: ["Valiloc"]),
    ],
    targets: [
        .target(
            name: "Valiloc",
            resources: [
                .process("Mocks")
            ]
        ),
        .testTarget(
            name: "ValilocTests",
            dependencies: ["Valiloc"]
        )
    ]
)
