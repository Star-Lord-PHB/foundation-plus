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
        .package(url: "https://github.com/apple/swift-system.git", from: "1.4.0"),],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .foundationPlus,
        .foundationPlusEssential,
        .fileManagerPlus,
        .concurrencyPlus,
        .datePlus,
        .glibcInterop,
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
        dependencies: [.foundationPlusEssential, .fileManagerPlus, .concurrencyPlus, .datePlus]
    )

    static let foundationPlusEssential: Target = .target(
        name: "FoundationPlusEssential",
        dependencies: [.concurrencyPlus],
        path: "Sources/Essential"
    )

#if canImport(Glibc)
    static let fileManagerPlus: Target = .target(
        name: "FileManagerPlus",
        dependencies: [.concurrencyPlus, .foundationPlusEssential, .swiftSystem, .glibcInterop],
        path: "Sources/FileManagerPlus"
    )
#else
    static let fileManagerPlus: Target = .target(
        name: "FileManagerPlus",
        dependencies: [.concurrencyPlus, .foundationPlusEssential, .swiftSystem],
        path: "Sources/FileManagerPlus"
    )
#endif

    static let concurrencyPlus: Target = .target(
        name: "ConcurrencyPlus",
        path: "Sources/ConcurrencyPlus"
    )

    static let datePlus: Target = .target(
        name: "DatePlus",
        path: "Sources/DatePlus"
    )

    static let glibcInterop: Target = .target(
        name: "GlibcInterop", 
        path: "Sources/GlibcInterop",
        publicHeadersPath: ".",
        cSettings: [.headerSearchPath(".")]
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

    static var fileManagerPlus: Self = "FileManagerPlus"

    static var datePlus: Self = "DatePlus"

    static var foundationPlus: Self = "FoundationPlus"

    static var swiftSystem: Self = .product(name: "SystemPackage", package: "swift-system")

    static var glibcInterop: Self = "GlibcInterop"

}
