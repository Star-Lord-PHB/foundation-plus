import Foundation



final class JoinableThread: Thread {

    private let task : () -> Void
    private let sem: DispatchSemaphore = .init(value: 0)

    init(block: sending @escaping () -> Void) {
        self.task = block
    }

    func join() {
        sem.wait()
        sem.signal()
    }

    override func main() {
        task()
        sem.signal()
    }

}