
extension BinaryInteger {

    @inlinable public func toInt() -> Int { .init(self) }
    @inlinable public func toIntTruncate() -> Int { .init(truncatingIfNeeded: self) }
    @inlinable public func toIntExact() -> Int? { .init(exactly: self) }

    @inlinable public func toInt8() -> Int8 { .init(self) }
    @inlinable public func toInt8Truncate() -> Int8 { .init(truncatingIfNeeded: self) }
    @inlinable public func toInt8Exact() -> Int8? { .init(exactly: self) }

    @inlinable public func toInt16() -> Int16 { .init(self) }
    @inlinable public func toInt16Truncate() -> Int16 { .init(truncatingIfNeeded: self) }
    @inlinable public func toInt16Exact() -> Int16? { .init(exactly: self) }

    @inlinable public func toInt32() -> Int32 { .init(self) }
    @inlinable public func toInt32Truncate() -> Int32 { .init(truncatingIfNeeded: self) }
    @inlinable public func toInt32Exact() -> Int32? { .init(exactly: self) }

    @inlinable public func toInt64() -> Int64 { .init(self) }
    @inlinable public func toInt64Truncate() -> Int64 { .init(truncatingIfNeeded: self) }
    @inlinable public func toInt64Exact() -> Int64? { .init(exactly: self) }

    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128() -> Int128 { .init(self) }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128Truncate() -> Int128 { .init(truncatingIfNeeded: self) }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128Exact() -> Int128? { .init(exactly: self) }


    @inlinable public func toUInt() -> UInt { .init(self) }
    @inlinable public func toUIntTruncate() -> UInt { .init(truncatingIfNeeded: self) }
    @inlinable public func toUIntExact() -> UInt? { .init(exactly: self) }

    @inlinable public func toUInt8() -> UInt8 { .init(self) }
    @inlinable public func toUInt8Truncate() -> UInt8 { .init(truncatingIfNeeded: self) }
    @inlinable public func toUInt8Exact() -> UInt8? { .init(exactly: self) }

    @inlinable public func toUInt16() -> UInt16 { .init(self) }
    @inlinable public func toUInt16Truncate() -> UInt16 { .init(truncatingIfNeeded: self) }
    @inlinable public func toUInt16Exact() -> UInt16? { .init(exactly: self) }

    @inlinable public func toUInt32() -> UInt32 { .init(self) }
    @inlinable public func toUInt32Truncate() -> UInt32 { .init(truncatingIfNeeded: self) }
    @inlinable public func toUInt32Exact() -> UInt32? { .init(exactly: self) }

    @inlinable public func toUInt64() -> UInt64 { .init(self) }
    @inlinable public func toUInt64Truncate() -> UInt64 { .init(truncatingIfNeeded: self) }
    @inlinable public func toUInt64Exact() -> UInt64? { .init(exactly: self) }

    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128() -> UInt128 { .init(self) }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128Truncate() -> UInt128 { .init(truncatingIfNeeded: self) }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128Exact() -> UInt128? { .init(exactly: self) }


    @inlinable public func toFloat() -> Float { .init(self) }
    @inlinable public func toFloatExact() -> Float? { .init(exactly: self) }

    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    @inlinable public func toFloat16() -> Float16 { .init(self) }
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    @inlinable public func toFloat16Exact() -> Float16? { .init(exactly: self) }

    @inlinable public func toFloat32() -> Float32 { .init(self) }
    @inlinable public func toFloat32Exact() -> Float32? { .init(exactly: self) }

    @inlinable public func toFloat64() -> Float64 { .init(self) }
    @inlinable public func toFloat64Exact() -> Float64? { .init(exactly: self) }

    @inlinable public func toDouble() -> Double { .init(self) }
    @inlinable public func toDoubleExact() -> Double? { .init(exactly: self) }

}



extension BinaryFloatingPoint {

    @inlinable public func toInt() -> Int { .init(self) }
    @inlinable public func toInt(_ rule: FloatingPointRoundingRule) -> Int { .init(self.rounded(rule)) }
    @inlinable public func toIntExact() -> Int? { .init(exactly: self) }
    @inlinable public func toIntExact(_ rule: FloatingPointRoundingRule) -> Int? { .init(exactly: self.rounded(rule)) }

    @inlinable public func toInt8() -> Int8 { .init(self) }
    @inlinable public func toInt8(_ rule: FloatingPointRoundingRule) -> Int8 { .init(self.rounded(rule)) }
    @inlinable public func toInt8Exact() -> Int8? { .init(exactly: self) }
    @inlinable public func toInt8Exact(_ rule: FloatingPointRoundingRule) -> Int8? { .init(exactly: self.rounded(rule)) }

    @inlinable public func toInt16() -> Int16 { .init(self) }
    @inlinable public func toInt16(_ rule: FloatingPointRoundingRule) -> Int16 { .init(self.rounded(rule)) }
    @inlinable public func toInt16Exact() -> Int16? { .init(exactly: self) }
    @inlinable public func toInt16Exact(_ rule: FloatingPointRoundingRule) -> Int16? { .init(exactly: self.rounded(rule)) }

    @inlinable public func toInt32() -> Int32 { .init(self) }
    @inlinable public func toInt32(_ rule: FloatingPointRoundingRule) -> Int32 { .init(self.rounded(rule)) }
    @inlinable public func toInt32Exact() -> Int32? { .init(exactly: self) }
    @inlinable public func toInt32Exact(_ rule: FloatingPointRoundingRule) -> Int32? { .init(exactly: self.rounded(rule)) }

    @inlinable public func toInt64() -> Int64 { .init(self) }
    @inlinable public func toInt64(_ rule: FloatingPointRoundingRule) -> Int64 { .init(self.rounded(rule)) }
    @inlinable public func toInt64Exact() -> Int64? { .init(exactly: self) }
    @inlinable public func toInt64Exact(_ rule: FloatingPointRoundingRule) -> Int64? { .init(exactly: self.rounded(rule)) }

    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128() -> Int128 { .init(self) }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128(_ rule: FloatingPointRoundingRule) -> Int128 { .init(self.rounded(rule)) }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128Exact() -> Int128? { .init(exactly: self) }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128Exact(_ rule: FloatingPointRoundingRule) -> Int128? { .init(exactly: self.rounded(rule)) }

    @inlinable public func toUInt() -> UInt { .init(self) }
    @inlinable public func toUInt(_ rule: FloatingPointRoundingRule) -> UInt { .init(self.rounded(rule)) }
    @inlinable public func toUIntExact() -> UInt? { .init(exactly: self) }
    @inlinable public func toUIntExact(_ rule: FloatingPointRoundingRule) -> UInt? { .init(exactly: self.rounded(rule)) }

    @inlinable public func toUInt8() -> UInt8 { .init(self) }
    @inlinable public func toUInt8(_ rule: FloatingPointRoundingRule) -> UInt8 { .init(self.rounded(rule)) }
    @inlinable public func toUInt8Exact() -> UInt8? { .init(exactly: self) }
    @inlinable public func toUInt8Exact(_ rule: FloatingPointRoundingRule) -> UInt8? { .init(exactly: self.rounded(rule)) }

    @inlinable public func toUInt16() -> UInt16 { .init(self) }
    @inlinable public func toUInt16(_ rule: FloatingPointRoundingRule) -> UInt16 { .init(self.rounded(rule)) }
    @inlinable public func toUInt16Exact() -> UInt16? { .init(exactly: self) }
    @inlinable public func toUInt16Exact(_ rule: FloatingPointRoundingRule) -> UInt16? { .init(exactly: self.rounded(rule)) }

    @inlinable public func toUInt32() -> UInt32 { .init(self) }
    @inlinable public func toUInt32(_ rule: FloatingPointRoundingRule) -> UInt32 { .init(self.rounded(rule)) }
    @inlinable public func toUInt32Exact() -> UInt32? { .init(exactly: self) }
    @inlinable public func toUInt32Exact(_ rule: FloatingPointRoundingRule) -> UInt32? { .init(exactly: self.rounded(rule)) }

    @inlinable public func toUInt64() -> UInt64 { .init(self) }
    @inlinable public func toUInt64(_ rule: FloatingPointRoundingRule) -> UInt64 { .init(self.rounded(rule)) }
    @inlinable public func toUInt64Exact() -> UInt64? { .init(exactly: self) }
    @inlinable public func toUInt64Exact(_ rule: FloatingPointRoundingRule) -> UInt64? { .init(exactly: self.rounded(rule)) }

    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128() -> UInt128 { .init(self) }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128(_ rule: FloatingPointRoundingRule) -> UInt128 { .init(self.rounded(rule)) }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128Exact() -> UInt128? { .init(exactly: self) }
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128Exact(_ rule: FloatingPointRoundingRule) -> UInt128? { .init(exactly: self.rounded(rule)) }

    @inlinable public func toFloat() -> Float { .init(self) }
    @inlinable public func toFloatExact() -> Float? { .init(exactly: self) }

    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    @inlinable public func toFloat16() -> Float16 { .init(self) }
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    @inlinable public func toFloat16Exact() -> Float16? { .init(exactly: self) }

    @inlinable public func toFloat32() -> Float32 { .init(self) }
    @inlinable public func toFloat32Exact() -> Float32? { .init(exactly: self) }

    @inlinable public func toFloat64() -> Float64 { .init(self) }
    @inlinable public func toFloat64Exact() -> Float64? { .init(exactly: self) }

    @inlinable public func toDouble() -> Double { .init(self) }
    @inlinable public func toDoubleExact() -> Double? { .init(exactly: self) }

}
