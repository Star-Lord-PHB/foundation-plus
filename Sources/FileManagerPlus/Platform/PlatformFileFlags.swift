import Foundation
#if os(Windows)
import WinSDK
#elseif os(Linux)
import Glibc
#endif


extension FileManager {

    /// A type representing platform-specific file flags.
    /// 
    /// - On Windows, it is the `dwFileAttributes` field 
    /// - On Darwin, it is the `st_flags` field in the `stat` structure
    /// - On Linux, it is get by the `ioctl` system call with `FS_IOC_GETFLAGS` request.
    /// 
    /// - Attention: On Linux, the flags are not available for symbolic links and may not
    /// be available for all file systems.
    /// 
    /// - Attention: The properties of this type are highly platform-specific. So be careful
    /// when using them on different platforms.
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