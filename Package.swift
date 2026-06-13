// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "VerticalSemaphore",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
    ],
    products: [
        .library(name: "VerticalSemaphore", targets: ["VerticalSemaphore"]),
    ],
    targets: [
        .target(name: "VerticalSemaphore"),
        .testTarget(
            name: "VerticalSemaphoreTests",
            dependencies: ["VerticalSemaphore"]
        ),
    ]
)
