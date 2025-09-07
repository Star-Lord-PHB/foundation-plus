import Foundation


@available(*, noasync, message: "Do NOT use this lock in async context")
struct SyncedConditionalLock: @unchecked Sendable {

    private let lock: NSCondition = .init()


    func wait<R, E: Error>(until condition: () -> Bool, do work: () throws(E) -> R) throws(E) -> R {
        lock.lock()
        while !condition() {
            lock.wait()
        }
        let result = try work()
        lock.unlock()
        return result
    }


    func wait<R, E: Error>(if condition: () -> Bool, do work: () throws(E) -> R) throws(E) -> R {
        lock.lock()
        if condition() {
            lock.wait()
        }
        let result = try work()
        lock.unlock()
        return result
    }


    func withLock<R, E: Error>(_ work: () throws(E) -> R) throws(E) -> R {
        lock.lock()
        let result = try work()
        lock.unlock()
        return result
    }


    func signal() {
        lock.signal()
    }


    func broadcast() {
        lock.broadcast()
    }
    
}