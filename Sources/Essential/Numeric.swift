
extension BinaryInteger {

    @inlinable public var intVal: Int { Int(truncatingIfNeeded: self) }
    @inlinable public var int8Val: Int8 { Int8(truncatingIfNeeded: self) }
    @inlinable public var int16Val: Int16 { Int16(truncatingIfNeeded: self) }
    @inlinable public var int32Val: Int32 { Int32(truncatingIfNeeded: self) }
    @inlinable public var int64Val: Int64 { Int64(truncatingIfNeeded: self) }

    @inlinable public var uIntVal: UInt { UInt(truncatingIfNeeded: self) }
    @inlinable public var uInt8Val: UInt8 { UInt8(truncatingIfNeeded: self) }
    @inlinable public var uInt16Val: UInt16 { UInt16(truncatingIfNeeded: self) }
    @inlinable public var uInt32Val: UInt32 { UInt32(truncatingIfNeeded: self) }
    @inlinable public var uInt64Val: UInt64 { UInt64(truncatingIfNeeded: self) }

    @inlinable public var floatVal: Float { Float(self) }
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    @inlinable public var float16Val: Float16 { Float16(self) }
    @inlinable public var float32Val: Float32 { Float32(self) }
    @inlinable public var float64Val: Float64 { Float64(self) }

    @inlinable public var doubleVal: Double { Double(self) }

}


extension BinaryFloatingPoint {

    @inlinable public var intVal: Int { Int(self) }
    @inlinable public var int8Val: Int8 { Int8(self) }
    @inlinable public var int16Val: Int16 { Int16(self) }
    @inlinable public var int32Val: Int32 { Int32(self) }
    @inlinable public var int64Val: Int64 { Int64(self) }

    @inlinable public var uIntVal: UInt { UInt(self) }
    @inlinable public var uInt8Val: UInt8 { UInt8(self) }
    @inlinable public var uInt16Val: UInt16 { UInt16(self) }
    @inlinable public var uInt32Val: UInt32 { UInt32(self) }
    @inlinable public var uInt64Val: UInt64 { UInt64(self) }

    @inlinable public var floatVal: Float { Float(self) }
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    @inlinable public var float16Val: Float16 { Float16(self) }
    @inlinable public var float32Val: Float32 { Float32(self) }
    @inlinable public var float64Val: Float64 { Float64(self) }

    @inlinable public var doubleVal: Double { Double(self) }

}
