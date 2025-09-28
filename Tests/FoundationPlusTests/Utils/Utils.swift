import Testing
import Foundation


final class MutexValue<V>: @unchecked Sendable {
    private var value: V
    private let lock = NSLock()
    init(_ value: consuming V) {
        self.value = value
    }
    func withLock<T, E: Error>(_ block: (inout V) throws(E) -> T) throws(E) -> T {
        lock.lock()
        defer { lock.unlock() }
        return try block(&value)
    }
}


func waitUntil(
    timeLimit: TimeInterval? = nil, 
    sourceLocation: SourceLocation = #_sourceLocation, 
    _ condition: () -> Bool
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



@discardableResult
func wait<E: Error, R: Sendable>(
    for timeLimit: TimeInterval,
    sourceLocation: SourceLocation = #_sourceLocation,
    operation: sending @escaping () async throws(E) -> R
) async throws -> R {
    
    let finished = MutexValue(false)

    let task = Task {
        defer { finished.withLock{ $0 = true } }
        return try await operation()
    }
    
    return try await withTaskCancellationHandler {
        try await waitUntil(timeLimit: timeLimit, sourceLocation: sourceLocation) {
            finished.withLock(\.self)
        }
        return try await task.value
    } onCancel: {
        task.cancel()
    }

}



final class SingleConsumerBarrier: Sendable {

    private let stream: AsyncStream<Void>
    private let continuation: AsyncStream<Void>.Continuation

    init() {
        var continuation: AsyncStream<Void>.Continuation! = nil
        self.stream = AsyncStream { cont in
            continuation = cont
        }
        self.continuation = continuation
    }

    deinit {
        continuation.finish()
    }

    func wait() async {
        await stream.first(where: { _ in true })
    }

    func signal() {
        continuation.yield()
    }

}
