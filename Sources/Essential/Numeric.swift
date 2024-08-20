import Foundation


extension Int: @retroactive Identifiable {
    public var id: Int { self }
}


extension BinaryInteger {

    public var intVal: Int { Int(truncatingIfNeeded: self) }
    public var int8Val: Int8 { Int8(truncatingIfNeeded: self) }
    public var int16Val: Int16 { Int16(truncatingIfNeeded: self) }
    public var int32Val: Int32 { Int32(truncatingIfNeeded: self) }
    public var int64Val: Int64 { Int64(truncatingIfNeeded: self) }

    public var uIntVal: UInt { UInt(truncatingIfNeeded: self) }
    public var uInt8Val: UInt8 { UInt8(truncatingIfNeeded: self) }
    public var uInt16Val: UInt16 { UInt16(truncatingIfNeeded: self) }
    public var uInt32Val: UInt32 { UInt32(truncatingIfNeeded: self) }
    public var uInt64Val: UInt64 { UInt64(truncatingIfNeeded: self) }

    public var floatVal: Float { Float(self) }
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    public var float16Val: Float16 { Float16(self) }
    public var float32Val: Float32 { Float32(self) }
    public var float64Val: Float64 { Float64(self) }

    public var doubleVal: Double { Double(self) }

}


extension BinaryFloatingPoint {

    public var intVal: Int { Int(self) }
    public var int8Val: Int8 { Int8(self) }
    public var int16Val: Int16 { Int16(self) }
    public var int32Val: Int32 { Int32(self) }
    public var int64Val: Int64 { Int64(self) }

    public var uIntVal: UInt { UInt(self) }
    public var uInt8Val: UInt8 { UInt8(self) }
    public var uInt16Val: UInt16 { UInt16(self) }
    public var uInt32Val: UInt32 { UInt32(self) }
    public var uInt64Val: UInt64 { UInt64(self) }

    public var floatVal: Float { Float(self) }
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    public var float16Val: Float16 { Float16(self) }
    public var float32Val: Float32 { Float32(self) }
    public var float64Val: Float64 { Float64(self) }

    public var doubleVal: Double { Double(self) }

}
