
import Foundation 


extension FileManager {

    public struct PosixPermission: Sendable {

        public fileprivate(set) var bits: UInt16

        public init(bits: UInt16) {
#if os(Windows)
            self.bits = bits & 0o700
#else 
            self.bits = bits & 0o777
#endif
        }

    }

}


extension FileManager.PosixPermission {

    public var userReadable: Bool {
        get { bits & 0o400 != 0 }
        set { setBits(for: &bits, at: 0o400, to: newValue) }
    }

    public var userWritable: Bool {
        get { bits & 0o200 != 0 }
        set { setBits(for: &bits, at: 0o200, to: newValue) }
    }

    public var userExecutable: Bool {
        get { bits & 0o100 != 0 }
        set { setBits(for: &bits, at: 0o100, to: newValue) }
    }

#if !os(Windows)

    public var groupReadable: Bool {
        get { bits & 0o40 != 0 }
        set { setBits(for: &bits, at: 0o40, to: newValue) }
    }


    public var groupWritable: Bool {
        get { bits & 0o20 != 0 }
        set { setBits(for: &bits, at: 0o20, to: newValue) }
    }


    public var groupExecutable: Bool {
        get { bits & 0o10 != 0 }
        set { setBits(for: &bits, at: 0o10, to: newValue) }
    }


    public var otherReadable: Bool {
        get { bits & 0o4 != 0 }
        set { setBits(for: &bits, at: 0o4, to: newValue) }
    }


    public var otherWritable: Bool {
        get { bits & 0o2 != 0 }
        set { setBits(for: &bits, at: 0o2, to: newValue) }
    }


    public var otherExecutable: Bool {
        get { bits & 0o1 != 0 }
        set { setBits(for: &bits, at: 0o1, to: newValue) }
    }

#endif

}



extension FileManager.PosixPermission {

    public static func | (lhs: Self, rhs: Self) -> Self {
        .init(bits: lhs.bits | rhs.bits)
    }

}


extension FileManager.PosixPermission: Equatable, Hashable {}


extension FileManager.PosixPermission: CustomStringConvertible {

    public var description: String { .init(bits, radix: 8) }

}


extension FileManager.PosixPermission: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: UInt16) {
        self.init(bits: value)
    }

}



extension FileManager.PosixPermission {

    public static let userRead: Self = .init(bits: 0o400)
    public static let userWrite: Self = .init(bits: 0o200)
    public static let userExecute: Self = .init(bits: 0o100)
    public static let userReadWrite: Self = .init(bits: 0o600)
    public static let userReadExecute: Self = .init(bits: 0o500)
    public static let userWriteExecute: Self = .init(bits: 0o300)
    public static let userReadWriteExecute: Self = .init(bits: 0o700)

#if !os(Windows)

    public static let groupRead: Self = .init(bits: 0o40)
    public static let groupWrite: Self = .init(bits: 0o20)
    public static let groupExecute: Self = .init(bits: 0o10)
    public static let groupReadWrite: Self = .init(bits: 0o60)
    public static let groupReadExecute: Self = .init(bits: 0o50)
    public static let groupWriteExecute: Self = .init(bits: 0o30)
    public static let groupReadWriteExecute: Self = .init(bits: 0o70)

    public static let otherRead: Self = .init(bits: 0o4)
    public static let otherWrite: Self = .init(bits: 0o2)
    public static let otherExecute: Self = .init(bits: 0o1)
    public static let otherReadWrite: Self = .init(bits: 0o6)
    public static let otherReadExecute: Self = .init(bits: 0o5)
    public static let otherWriteExecute: Self = .init(bits: 0o3)
    public static let otherReadWriteExecute: Self = .init(bits: 0o7)

#endif

}



extension FileManager.PosixPermission {

    fileprivate func setBits(for bits: inout UInt16, at mask: UInt16, to value: Bool) {
        if value {
            bits |= mask
        } else {
            bits &= ~mask
        }
    }

}