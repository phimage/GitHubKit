// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "GitHubKit",
    products: [
        .library(name: "GitHubKit", targets: ["GitHubKit"]),
        .library(name: "GitHubKitMocks", targets: ["GitHubKitMocks"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.1.1")
    ],
    targets: [
        .target(
            name: "GitHubKit",
            dependencies: [
                "AsyncHTTPClient"
            ]
        ),
        .target(
            name: "GitHubKitMocks",
            dependencies: [
                "GitHubKit"
            ]
        ),
        .testTarget(
            name: "GitHubKitMocksTests",
            dependencies: [
                "GitHubKitMocks"
            ]
        )
    ]
)

