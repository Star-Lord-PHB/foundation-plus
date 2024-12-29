import Foundation
#if os(Windows)
import WinSDK
#elseif os(Linux)
import Glibc
#endif


extension FileManager {

    public struct PlatformFileFlags: Sendable {

#if os(Windows)
        public typealias BitValue = DWORD
#else
        public typealias BitValue = UInt32
#endif

        public internal(set) var bits: BitValue


        public init(bits: BitValue) {
            self.bits = bits
        }

        public init(bits: Int32) {
            self.init(bits: .init(bitPattern: bits))
        }


        mutating func setBits(_ mask: BitValue, to active: Bool) {
            if active {
                self.bits |= mask
            } else {
                self.bits &= ~mask
            }
            
        }


        mutating func setBits<V: BinaryInteger>(_ mask: V, to active: Bool) {
            self.setBits(.init(mask), to: active)
        }


    }

}


extension FileManager.PlatformFileFlags: Equatable, Hashable {}


extension FileManager.PlatformFileFlags: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Int) {
        self.init(bits: BitValue(value))
    }

}