// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "GraphStorage",
    platforms: [
        .macOS("13.0"), .iOS("16.0"), .tvOS(.v14)
    ],
    products: [
        .library(
            name: "GraphStorage",
            targets: ["GraphStorage"]
        )
    ],
    targets: [
        .target(
            name: "GraphStorage",
            dependencies: []
        ),
        .testTarget(
            name: "GraphStorageTests",
            dependencies: ["GraphStorage"]
        )
    ]
)
