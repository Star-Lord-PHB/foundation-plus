import Testing
@testable import FoundationPlus


final class DurationCompatTest {

    @Test(
        arguments: [
            (-1224065918.int64Val, 1305441957.int64Val),
        ]
    )
    @available(iOS, deprecated: 16)
    @available(macOS, deprecated: 13)
    @available(watchOS, deprecated: 9)
    @available(tvOS, deprecated: 16)
    func creating(seconds: Int64, attoSeconds: Int64) throws {

        let expected = Duration(secondsComponent: seconds, attosecondsComponent: attoSeconds)
        let timeDuration = DurationCompat(secondsComponent: seconds, attosecondsComponent: attoSeconds)

        print("seconds: \(seconds) attoSeconds: \(attoSeconds)")
        print("calclated: \(timeDuration)")
        print("expected: \(expected.components)")

        #expect(expected == timeDuration)

    }


    @Test
    @available(iOS, deprecated: 16)
    @available(macOS, deprecated: 13)
    @available(watchOS, deprecated: 9)
    @available(tvOS, deprecated: 16)
    func creatingRepeat() throws {

        for _ in 0 ..< 10 {
            
            let randomSeconds = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)
            let randomAttoSeconds = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)

            let expected = Duration(secondsComponent: randomSeconds, attosecondsComponent: randomAttoSeconds)

            let timeDuration = DurationCompat(secondsComponent: randomSeconds, attosecondsComponent: randomAttoSeconds)

            print("seconds: \(randomSeconds) attoSeconds: \(randomAttoSeconds)")
            print("calclated: \(timeDuration)")
            print("expected: \(expected.components)")

            #expect(expected == timeDuration)
            
        }

    }


    @Test(
        arguments: [
            (1551283931.int64Val, 0.int64Val, (10 ** 18).int64Val)
        ]
    )
    @available(iOS, deprecated: 16)
    @available(macOS, deprecated: 13)
    @available(watchOS, deprecated: 9)
    @available(tvOS, deprecated: 16)
    func divide(seconds: Int64, attoSeconds: Int64, factor: Int64) throws {
        
        let expected = Duration(secondsComponent: seconds, attosecondsComponent: attoSeconds) / factor
        
        let timeDuration1 = DurationCompat(secondsComponent: seconds, attosecondsComponent: attoSeconds)
        let result = timeDuration1 / factor.intVal
        
        print("seconds: \(seconds) attoSeconds: \(attoSeconds) factor: \(factor)")
        
        #expect(expected == result)
        
    }


    @Test
    @available(iOS, deprecated: 16)
    @available(macOS, deprecated: 13)
    @available(watchOS, deprecated: 9)
    @available(tvOS, deprecated: 16)
    func divideRepeat() throws {
        
        for _ in 0 ..< 10 {
            
            let randomSeconds = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)
            let randomAttoSeconds = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)
            let randomFactor = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)
            
            let expected = Duration(secondsComponent: randomSeconds, attosecondsComponent: randomAttoSeconds) / randomFactor
            
            let timeDuration1 = DurationCompat(secondsComponent: randomSeconds, attosecondsComponent: randomAttoSeconds)
            let result = timeDuration1 / randomFactor.intVal
            
            print("seconds: \(randomSeconds) attoSeconds: \(randomAttoSeconds) factor: \(randomFactor)")
            
            #expect(expected == result)
            
        }
        
    }
    
    
    @Test(
        arguments: [
            (1741079210.int64Val, -719576355.int64Val, 1031414766.int64Val, -1427627192.int64Val)
        ]
    )
    @available(iOS, deprecated: 16)
    @available(macOS, deprecated: 13)
    @available(watchOS, deprecated: 9)
    @available(tvOS, deprecated: 16)
    func divide2(seconds1: Int64, attoSeconds1: Int64, seconds2: Int64, attoSeconds2: Int64) throws {
        
        let duration1 = Duration(secondsComponent: seconds1, attosecondsComponent: attoSeconds1)
        let duration2 = Duration(secondsComponent: seconds2, attosecondsComponent: attoSeconds2)
        let expected = duration1 / duration2
        
        let timeDuration1 = DurationCompat(secondsComponent: seconds1, attosecondsComponent: attoSeconds1)
        let timeDuration2 = DurationCompat(secondsComponent: seconds2, attosecondsComponent: attoSeconds2)
        let result = timeDuration1 / timeDuration2
        
        print("duration1: \(timeDuration1) duration2: \(duration2)")
        print("result: \(result) expected: \(expected)")
        
        #expect(expected == result)
        
    }
    
    
    @Test
    @available(iOS, deprecated: 16)
    @available(macOS, deprecated: 13)
    @available(watchOS, deprecated: 9)
    @available(tvOS, deprecated: 16)
    func divide2Repeat() throws {
        
        for _ in 0 ..< 10 {
            
            let seconds1 = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)
            let attoSeconds1 = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)
            let seconds2 = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)
            let attoSeconds2 = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)
            
            let duration1 = Duration(secondsComponent: seconds1, attosecondsComponent: attoSeconds1)
            let duration2 = Duration(secondsComponent: seconds2, attosecondsComponent: attoSeconds2)
            let expected = duration1 / duration2
            
            let timeDuration1 = DurationCompat(secondsComponent: seconds1, attosecondsComponent: attoSeconds1)
            let timeDuration2 = DurationCompat(secondsComponent: seconds2, attosecondsComponent: attoSeconds2)
            let result = timeDuration1 / timeDuration2
            
            print("duration1: \(timeDuration1) duration2: \(duration2)")
            print("result: \(result) expected: \(expected)")
            
            #expect(expected == result)
            
        }
        
    }
    
    
    @Test(
        arguments: [
            (-1022399910.int64Val, -226561216.int64Val, -1123732875.int64Val)
        ]
    )
    @available(iOS, deprecated: 16)
    @available(macOS, deprecated: 13)
    @available(watchOS, deprecated: 9)
    @available(tvOS, deprecated: 16)
    func multiply(seconds: Int64, attoSeconds: Int64, factor: Int64) throws {
        
        let expected = Duration(secondsComponent: seconds, attosecondsComponent: attoSeconds) * factor
        
        let timeDuration1 = DurationCompat(secondsComponent: seconds, attosecondsComponent: attoSeconds)
        let result = timeDuration1 * (factor.intVal)
        
        print("duration: \(timeDuration1) factor: \(factor)")
        print("result: \(result)")
        
        if !(expected == result) {
            let _ = timeDuration1 * (factor.intVal)
        }
        
        #expect(expected == result)
        
    }


    @Test
    @available(iOS, deprecated: 16)
    @available(macOS, deprecated: 13)
    @available(watchOS, deprecated: 9)
    @available(tvOS, deprecated: 16)
    func multiplyRepeat() throws {

        for _ in 0 ..< 10 {
            
            let randomSeconds = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)
            let randomAttoSeconds = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)
            let randomFactor = Int64.random(in: Int32.min.int64Val ... Int32.max.int64Val)

            let expected = Duration(secondsComponent: randomSeconds, attosecondsComponent: randomAttoSeconds) * randomFactor

            let timeDuration1 = DurationCompat(secondsComponent: randomSeconds, attosecondsComponent: randomAttoSeconds)
            let result = timeDuration1 * (randomFactor.intVal)

            print("duration: \(timeDuration1) factor: \(randomFactor)")
            print("result: \(result)")
            
            if !(expected == result) {
                let _ = timeDuration1 * (randomFactor.intVal)	
            }

            #expect(expected == result)
            
        }

    }
    
    
    @Test
    @available(iOS, deprecated: 16)
    @available(macOS, deprecated: 13)
    @available(watchOS, deprecated: 9)
    @available(tvOS, deprecated: 16)
    func staticCreating() throws {
        
        let nanoseconds = Int64.random(in: Int64.min ... Int64.max)
        var timeDuration = DurationCompat.nanoseconds(nanoseconds)
        var duration = Duration.nanoseconds(nanoseconds)
        #expect(duration == timeDuration)
        
        let microseconds = Int32.random(in: Int32.min ... Int32.max)
        timeDuration = DurationCompat.microseconds(microseconds)
        duration = Duration.microseconds(microseconds)
        #expect(duration == timeDuration)
        
        let microsecondsDouble = Double.random(in: Int64.min.doubleVal ... Int64.max.doubleVal)
        timeDuration = DurationCompat.microseconds(microsecondsDouble)
        duration = Duration.microseconds(microsecondsDouble)
        #expect(duration == timeDuration)
        
        let milliseconds = Int32.random(in: Int32.min ... Int32.max)
        timeDuration = DurationCompat.milliseconds(milliseconds)
        duration = Duration.milliseconds(milliseconds)
        #expect(duration == timeDuration)
        
        let millisecondsDouble = Double.random(in: Int64.min.doubleVal ... Int64.max.doubleVal)
        timeDuration = DurationCompat.milliseconds(millisecondsDouble)
        duration = Duration.milliseconds(millisecondsDouble)
        #expect(duration == timeDuration)
        
        let seconds = Int32.random(in: Int32.min ... Int32.max)
        timeDuration = DurationCompat.seconds(seconds)
        duration = Duration.seconds(seconds)
        #expect(duration == timeDuration)
        
        let secondsDouble = Double.random(in: Int64.min.doubleVal ... Int64.max.doubleVal)
        timeDuration = DurationCompat.seconds(secondsDouble)
        duration = Duration.seconds(secondsDouble)
        #expect(duration == timeDuration)
        
    }

}
