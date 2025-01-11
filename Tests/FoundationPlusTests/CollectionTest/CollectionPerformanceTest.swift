import Testing
@testable import FoundationPlusEssential


@Suite(.enableWhenRelease)
struct CollectionPerformanceTest {

    @Test(.enableWhenRelease)
    func dropLastPerformance1() async throws {
        
        let collection = Array(0..<10000000)

        var bin = [] as ArraySlice<Int>
        _ = bin     // just to silence the warning

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin = collection.dropLast(while: { $0 < Int.max })
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin = collection.reversed().drop(while: { $0 < Int.max })
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }


    @Test(.enableWhenRelease)
    func dropLastPerformance2() async throws {
        
        let collection = String(repeating: "1", count: 10000000)

        var bin1 = "" as Substring
        var bin2 = "".reversed().dropLast(0)
        _ = bin1     // just to silence the warning
        _ = bin2     // just to silence the warning

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin1 = collection.dropLast(while: { !$0.isWhitespace })
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin2 = collection.reversed().drop(while: { !$0.isWhitespace })
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }


    @Test(.enableWhenRelease)
    func suffixPerformance1() async throws {
        
        let collection = Array(0..<10000000)

        var bin = [] as ArraySlice<Int>
        _ = bin     // just to silence the warning

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin = collection.suffix(while: { $0 < Int.max })
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin = collection.reversed().prefix(while: { $0 < Int.max })
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }


    @Test(.enableWhenRelease)
    func suffixPerformance2() async throws {
        
        let collection = String(repeating: "1", count: 10000000)

        var bin1 = "" as Substring
        var bin2 = "".reversed().dropLast(0)
        _ = bin1    // just to silence the warning
        _ = bin2    // just to silence the warning

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin1 = collection.suffix(while: { !$0.isWhitespace })
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin2 = collection.reversed().prefix(while: { !$0.isWhitespace })
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }


    @Test(.enableWhenRelease)
    func trimmingSuffix1() async throws {
        
        let collection = Array(0..<10000000)

        var bin = [] as ArraySlice<Int>
        _ = bin     // just to silence the warning

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin = collection.trimmingSuffix(while: { $0 < Int.max })
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin = collection.reversed().trimmingPrefix(while: { $0 < Int.max })
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }


    @Test(.enableWhenRelease)
    func trimmingSuffix2() async throws {
        
        let collection = String(repeating: "1", count: 10000000)

        var bin1 = "" as Substring
        var bin2 = "".reversed().dropLast(0)
        _ = bin1    // just to silence the warning
        _ = bin2    // just to silence the warning

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin1 = collection.trimmingSuffix(while: { !$0.isWhitespace })
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin2 = collection.reversed().trimmingPrefix(while: { !$0.isWhitespace })
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }


    @Test(.enableWhenRelease)
    func trimmingSuffix3() async throws {
        
        let collection = Array(0..<10000000)
        let suffix = collection.dropLast(collection.count / 2)
        let reversedSuffix = suffix.reversed()

        var bin = [] as ArraySlice<Int>
        _ = bin     // just to silence the warning

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin = collection.trimmingSuffix(suffix)
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin = collection.reversed().trimmingPrefix(reversedSuffix)
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }


    @Test(.enableWhenRelease)
    func trimmingSuffix4() async throws {
        
        let collection = String(repeating: "1", count: 10000000)
        let suffix = collection.dropLast(collection.count / 2)
        let reversedSuffix = suffix.reversed()

        var bin1 = "" as Substring
        var bin2 = "".reversed().dropLast(0)
        _ = bin1     // just to silence the warning
        _ = bin2     // just to silence the warning

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin1 = collection.trimmingSuffix(suffix)
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                bin2 = collection.reversed().trimmingPrefix(reversedSuffix)
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }


    @Test(.enableWhenRelease)
    func trimSuffix1() async throws {

        var collection1 = Array(0..<10000000)
        var collection2 = Array(0..<10000000)

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                collection1.trimSuffix(while: { $0 < Int.max })
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                collection2.trimPrefix(while: { $0 < Int.max })
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }


    @Test(.enableWhenRelease)
    func trimSuffix2() async throws {

        var collection1 = String(repeating: "1", count: 10000000)
        var collection2 = String(repeating: "1", count: 10000000)

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                collection1.trimSuffix(while: { !$0.isWhitespace })
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                collection2.trimPrefix(while: { !$0.isWhitespace })
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }


    @Test(.enableWhenRelease)
    func trimSuffix3() async throws {

        var collection1 = Array(0..<10000000)
        var collection2 = Array(0..<10000000)
        let suffix = collection1.dropFirst(collection1.count / 2)
        let prefix = collection2.dropLast(collection2.count / 2)

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                collection1.trimSuffix(suffix)
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                collection2.trimPrefix(prefix)
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }


    @Test(.enableWhenRelease)
    func trimSuffix4() async throws {

        var collection1 = String(repeating: "1", count: 10000000)
        var collection2 = String(repeating: "1", count: 10000000)
        let suffix = collection1.dropFirst(collection1.count / 2)
        let prefix = collection2.dropLast(collection2.count / 2)

        let time1 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                collection1.trimSuffix(suffix)
            }
        } / 20

        let time2 = (0 ..< 20).reduce(Duration.zero) { partialResult, _ in
            partialResult + ContinuousClock.continuous.measure {
                collection2.trimPrefix(prefix)
            }
        } / 20

        #expect(time1 < time2)

        print("standard: \(time2)")
        print("new: \(time1)")

    }

}



extension Trait where Self == ConditionTrait {

    public static var enableWhenRelease: ConditionTrait {
        .enabled {
            #if DEBUG
            return false
            #else
            return true
            #endif
        }
    }

}