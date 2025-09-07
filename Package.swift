// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let packageName: String = "FoundationPlus"

let package = Package(
    name: packageName,
    platforms: [.macOS(.v10_15), .iOS(.v13), .watchOS(.v6), .tvOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FoundationPlus",
            targets: ["FoundationPlus"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections", from: "1.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .foundationPlus,
        .foundationPlusEssential,
        .concurrencyPlus,
        .datePlus,
        .foundationPlusTests,
    ]
)


package.targets.forEach {
    var swiftSetting = $0.swiftSettings ?? []
    swiftSetting.append(.enableExperimentalFeature("StrictConcurrency"))
    $0.swiftSettings = swiftSetting
}


@MainActor
extension Target {

    static let foundationPlus: Target = .target(
        name: "FoundationPlus",
        dependencies: [.foundationPlusEssential, .concurrencyPlus, .datePlus]
    )

    static let foundationPlusEssential: Target = .target(
        name: "FoundationPlusEssential",
        dependencies: [.concurrencyPlus],
        path: "Sources/Essential"
    )

    static let concurrencyPlus: Target = .target(
        name: "ConcurrencyPlus",
        dependencies: [.deque],
        path: "Sources/ConcurrencyPlus"
    )

    static let datePlus: Target = .target(
        name: "DatePlus",
        path: "Sources/DatePlus"
    )

    static let foundationPlusTests: Target = .testTarget(
        name: "FoundationPlusTests",
        dependencies: [.foundationPlus]
    )

}


@MainActor
extension Target.Dependency {

    static let foundationPlusEssential: Self = "FoundationPlusEssential"

    static var concurrencyPlus: Self = "ConcurrencyPlus"

    static var datePlus: Self = "DatePlus"

    static var foundationPlus: Self = "FoundationPlus"

    static var deque: Self = .product(name: "DequeModule", package: "swift-collections")

}
