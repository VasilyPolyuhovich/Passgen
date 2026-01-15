// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "passgen",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/soffes/HotKey", from: "0.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "passgen",
            dependencies: ["HotKey"]
        ),
    ]
)
