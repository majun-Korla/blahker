// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Features",
            targets: ["Features"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.14.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.3.9"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Features",
            dependencies: [.tca]
        ),
        .testTarget(
            name: "FeaturesTests",
            dependencies: ["Features", .tca]),
    ])


// First party

extension Target.Dependency {
    static let tca = Self.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
}
