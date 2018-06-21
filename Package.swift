// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "HigherKindSwift",
    products: [
        .library(
            name: "HigherKindSwift",
            targets: ["HigherKindSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-prelude.git", .revision("25773a7")),
        .package(url: "https://github.com/typelift/SwiftCheck.git", from: "0.7.0")
    ],
    targets: [
        .target(
            name: "HigherKindSwift",
            dependencies: []),
        .testTarget(
            name: "HigherKindSwiftTests",
            dependencies: ["HigherKindSwift", "Prelude", "SwiftCheck"]),
    ]
)
