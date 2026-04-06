// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription

let package = Package(
    name: "SwiftUIKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftUIKit",
            targets: ["SwiftUIKit"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftUIKit",
            path: "Sources/SwiftUIKit"
        ),
        .testTarget(
            name: "SwiftUIKitTests",
            dependencies: ["SwiftUIKit"],
            path: "Tests/SwiftUIKitTests"
        ),
    ]
)
