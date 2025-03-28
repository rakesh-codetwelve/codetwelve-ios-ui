// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "CodetwelveUI",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "CodetwelveUI",
            targets: ["CodetwelveUI"]),
    ],
    dependencies: [
        // No external dependencies initially
    ],
    targets: [
        .target(
            name: "CodetwelveUI",
            dependencies: [],
            path: "Sources/CodetwelveUI",
            exclude: [
                "**/.gitkeep",
                "**/.DS_Store"
            ],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "CodetwelveUITests",
            dependencies: ["CodetwelveUI"],
            path: "Tests/CodetwelveUITests"),
    ]
)