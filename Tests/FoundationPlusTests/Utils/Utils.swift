import Testing
import Foundation


final class MutexValue<V>: @unchecked Sendable {
    private var value: V
    private let lock = NSLock()
    init(_ value: consuming V) {
        self.value = value
    }
    func withLock<T>(_ block: (inout V) throws -> T) rethrows -> T {
        lock.lock()
        defer { lock.unlock() }
        return try block(&value)
    }
}


func waitUntil(
    timeLimit: TimeInterval? = nil, 
    sourceLocation: SourceLocation = #_sourceLocation, 
    _ condition: @escaping () -> Bool
) async throws {
    let start = Date()
    while !condition() {
        if let timeLimit {
            let timeElapsed = Date().timeIntervalSince(start)
            try #require(
                timeElapsed < timeLimit, 
                "time limit exceeded", 
                sourceLocation: sourceLocation
            )
        }
        try await Task.sleep(nanoseconds: 100_000_000)
    }
}