// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let packageName: String = "FoundationPlus"

let package = Package(
    name: packageName,
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FoundationPlus",
            targets: ["FoundationPlus"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-testing.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-system.git", from: "1.4.0"),],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FoundationPlus",
            dependencies: [.foundationPlusEssential, .fileManagerPlus, .concurrencyPlus, .datePlus]),
        .target(
            name: "FoundationPlusEssential",
            dependencies: [.concurrencyPlus],
            path: "Sources/Essential"),
        .target(
            name: "FileManagerPlus",
            dependencies: [.concurrencyPlus, .foundationPlusEssential, .swiftSystem],
            path: "Sources/FileManagerPlus"),
        .target(
            name: "ConcurrencyPlus",
            path: "Sources/ConcurrencyPlus"),
        .target(
            name: "DatePlus",
            path: "Sources/DatePlus"),
        .testTarget(
            name: "FoundationPlusTests",
            dependencies: [.foundationPlus, .swiftTesting]),
    ]
)


package.targets.forEach {
    var swiftSetting = $0.swiftSettings ?? []
    swiftSetting.append(.enableExperimentalFeature("StrictConcurrency"))
    $0.swiftSettings = swiftSetting
}


@MainActor
extension Target.Dependency {

    static let foundationPlusEssential: Self = "FoundationPlusEssential"

    static var concurrencyPlus: Self = "ConcurrencyPlus"

    static var fileManagerPlus: Self = "FileManagerPlus"

    static var datePlus: Self = "DatePlus"

    static var foundationPlus: Self = "FoundationPlus"

    static var swiftTesting: Self = .product(name: "Testing", package: "swift-testing")

    static var swiftSystem: Self = .product(name: "SystemPackage", package: "swift-system")

}
