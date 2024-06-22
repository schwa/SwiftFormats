// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftFormats",
    platforms: [
        .iOS("16.0"),
        .macOS("13.0"),
        .macCatalyst("16.0"),
    ],
    products: [
        .library(
            name: "SwiftFormats",
            targets: ["SwiftFormats"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftFormats",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]
        ),
        .testTarget(
            name: "SwiftFormatsTests",
            dependencies: ["SwiftFormats"]
        ),
    ]
)
