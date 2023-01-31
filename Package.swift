// swift-tools-version: 5.7
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
        .package(url: "https://github.com/schwa/SIMD-Support", from: "0.0.2"),
    ],
    targets: [
        .target(
            name: "SwiftFormats",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "SIMDSupport", package: "SIMD-Support"),
            ]
        ),
        .testTarget(
            name: "SwiftFormatsTests",
            dependencies: ["SwiftFormats"]
        ),
    ]
)
