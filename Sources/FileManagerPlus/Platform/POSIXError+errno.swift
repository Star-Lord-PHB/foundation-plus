import Foundation


extension POSIXError {

    /// - Note: Implementation based on https://github.com/swiftlang/swift-foundation/blob/main/Sources/FoundationEssentials/Error/CocoaError%2BFilePath.swift
    init?(errno: Int32) {
        guard errno != EOPNOTSUPP else { return nil }
        guard let code = POSIXError.Code(rawValue: errno) else {
            fatalError("Invalid posix errno \(errno)")
        }
        self.init(code)
    }

}