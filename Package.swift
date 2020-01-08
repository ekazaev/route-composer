// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "RouteComposer",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "RouteComposer",
            targets: ["RouteComposer"])
    ],
    targets: [
        .target(
            name: "RouteComposer",
            dependencies: [],
            path: "RouteComposer/Classes"),
        .testTarget(
            name: "RouteComposerTests",
            dependencies: ["RouteComposer"],
            path: "Example/Tests")
    ],
    swiftLanguageVersions: [.v5]
)
