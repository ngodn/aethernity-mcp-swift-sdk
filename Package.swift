// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aethernity-mcp-swift-sdk",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AethernityMCP",
            targets: ["AethernityMCP"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-system.git", from: "1.4.2"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AethernityMCP",
            dependencies: [
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "Logging", package: "swift-log"),
            ]),
        .testTarget(
            name: "AethernityMCPTests",
            dependencies: [
                "AethernityMCP",
                .product(name: "SystemPackage", package: "swift-system"),
                .product(name: "Logging", package: "swift-log"),
            ]),
    ]
)
