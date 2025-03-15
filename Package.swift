// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aethernity-mcp-swift-sdk",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        // Linux is supported natively without platform restrictions
    ],
    products: [
        .library(
            name: "AethernityContextProtocol",
            targets: ["AethernityContextProtocol"]),
        .library(
            name: "AethernityContextServer",
            targets: ["AethernityContextServer"]),
        .library(
            name: "AethernityContextClient",
            targets: ["AethernityContextClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/samalone/websocket-actor-system.git", branch: "main"),
        .package(url: "https://github.com/kevinhermawan/swift-json-schema.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "AethernityContextProtocol",
            dependencies: [
                .product(name: "WebSocketActors", package: "websocket-actor-system"),
                .product(name: "JSONSchema", package: "swift-json-schema"),
            ]
        ),
        .target(
            name: "AethernityContextServer",
            dependencies: [
                "AethernityContextProtocol",
                .product(name: "WebSocketActors", package: "websocket-actor-system"),
            ]
        ),
        .target(
            name: "AethernityContextClient",
            dependencies: [
                "AethernityContextProtocol",
                .product(name: "WebSocketActors", package: "websocket-actor-system"),
            ]
        ),
    ]
)
