// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIKitCellConfigurator",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12)
    ],
    products: [
        .library(
            name: "UIKitCellConfigurator",
            targets: ["UIKitCellConfigurator"]),
    ],
    targets: [
        .target(
            name: "UIKitCellConfigurator",
            dependencies: []),
        .testTarget(
            name: "UIKitCellConfiguratorTests",
            dependencies: ["UIKitCellConfigurator"]),
    ]
)
