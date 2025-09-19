
extension BinaryInteger {

    /// Convert the BinaryInteger value to Int, same as calling `Int(value)`.
    @inlinable public func toInt() -> Int { .init(self) }
    /// Convert the BinaryInteger value to Int while sign-extending or truncating it to fit.
    /// 
    /// Same as calling `Int(truncatingIfNeeded: value)`. 
    @inlinable public func toIntTruncate() -> Int { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to Int if it can be represented exactly, otherwise returns nil.
    /// 
    /// Same as calling `Int(exactly: value)`.
    @inlinable public func toIntExact() -> Int? { .init(exactly: self) }

    /// Convert the BinaryInteger value to Int8, same as calling `Int8(value)`.
    @inlinable public func toInt8() -> Int8 { .init(self) }
    /// Convert the BinaryInteger value to Int8 while sign-extending or truncating it to fit
    /// 
    /// Same as calling `Int8(truncatingIfNeeded: value)`.
    @inlinable public func toInt8Truncate() -> Int8 { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to Int8 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Int8(exactly: value)`.
    @inlinable public func toInt8Exact() -> Int8? { .init(exactly: self) }

    /// Convert the BinaryInteger value to Int16, same as calling `Int16(value)`.
    @inlinable public func toInt16() -> Int16 { .init(self) }
    /// Convert the BinaryInteger value to Int16 while sign-extending or truncating it to fit
    /// 
    /// Same as calling `Int16(truncatingIfNeeded: value)`.
    @inlinable public func toInt16Truncate() -> Int16 { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to Int16 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Int16(exactly: value)`.
    @inlinable public func toInt16Exact() -> Int16? { .init(exactly: self) }

    /// Convert the BinaryInteger value to Int32, same as calling `Int32(value)`.
    @inlinable public func toInt32() -> Int32 { .init(self) }
    /// Convert the BinaryInteger value to Int32 while sign-extending or truncating it to fit
    /// 
    /// Same as calling `Int32(truncatingIfNeeded: value)`.
    @inlinable public func toInt32Truncate() -> Int32 { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to Int32 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Int32(exactly: value)`.
    @inlinable public func toInt32Exact() -> Int32? { .init(exactly: self) }

    /// Convert the BinaryInteger value to Int64, same as calling `Int64(value)`.
    @inlinable public func toInt64() -> Int64 { .init(self) }
    /// Convert the BinaryInteger value to Int64 while sign-extending or truncating it to fit
    /// 
    /// Same as calling `Int64(truncatingIfNeeded: value)`.
    @inlinable public func toInt64Truncate() -> Int64 { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to Int64 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Int64(exactly: value)`.
    @inlinable public func toInt64Exact() -> Int64? { .init(exactly: self) }

    /// Convert the BinaryInteger value to Int128, same as calling `Int128(value)`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128() -> Int128 { .init(self) }
    /// Convert the BinaryInteger value to Int128 while sign-extending or truncating it to fit
    /// 
    /// Same as calling `Int128(truncatingIfNeeded: value)`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128Truncate() -> Int128 { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to Int128 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Int128(exactly: value)`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128Exact() -> Int128? { .init(exactly: self) }


    /// Convert the BinaryInteger value to UInt, same as calling `UInt(value)`.
    @inlinable public func toUInt() -> UInt { .init(self) }
    /// Convert the BinaryInteger value to UInt while sign-extending or truncating it to fit
    /// 
    /// Same as calling `UInt(truncatingIfNeeded: value)`.
    @inlinable public func toUIntTruncate() -> UInt { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to UInt if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt(exactly: value)`.
    @inlinable public func toUIntExact() -> UInt? { .init(exactly: self) }

    /// Convert the BinaryInteger value to UInt8, same as calling `UInt8(value)`.
    @inlinable public func toUInt8() -> UInt8 { .init(self) }
    /// Convert the BinaryInteger value to UInt8 while sign-extending or truncating it to fit
    /// 
    /// Same as calling `UInt8(truncatingIfNeeded: value)`.
    @inlinable public func toUInt8Truncate() -> UInt8 { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to UInt8 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt8(exactly: value)`.
    @inlinable public func toUInt8Exact() -> UInt8? { .init(exactly: self) }

    /// Convert the BinaryInteger value to UInt16, same as calling `UInt16(value)`.
    @inlinable public func toUInt16() -> UInt16 { .init(self) }
    /// Convert the BinaryInteger value to UInt16 while sign-extending or truncating it to fit
    /// 
    /// Same as calling `UInt16(truncatingIfNeeded: value)`.
    @inlinable public func toUInt16Truncate() -> UInt16 { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to UInt16 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt16(exactly: value)`.
    @inlinable public func toUInt16Exact() -> UInt16? { .init(exactly: self) }

    /// Convert the BinaryInteger value to UInt32, same as calling `UInt32(value)`.
    @inlinable public func toUInt32() -> UInt32 { .init(self) }
    /// Convert the BinaryInteger value to UInt32 while sign-extending or truncating it to fit
    /// 
    /// Same as calling `UInt32(truncatingIfNeeded: value)`.
    @inlinable public func toUInt32Truncate() -> UInt32 { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to UInt32 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt32(exactly: value)`.
    @inlinable public func toUInt32Exact() -> UInt32? { .init(exactly: self) }

    /// Convert the BinaryInteger value to UInt64, same as calling `UInt64(value)`.
    @inlinable public func toUInt64() -> UInt64 { .init(self) }
    /// Convert the BinaryInteger value to UInt64 while sign-extending or truncating it to fit
    /// 
    /// Same as calling `UInt64(truncatingIfNeeded: value)`.
    @inlinable public func toUInt64Truncate() -> UInt64 { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to UInt64 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt64(exactly: value)`.
    @inlinable public func toUInt64Exact() -> UInt64? { .init(exactly: self) }

    /// Convert the BinaryInteger value to UInt128, same as calling `UInt128(value)`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128() -> UInt128 { .init(self) }
    /// Convert the BinaryInteger value to UInt128 while sign-extending or truncating it to fit
    /// 
    /// Same as calling `UInt128(truncatingIfNeeded: value)`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128Truncate() -> UInt128 { .init(truncatingIfNeeded: self) }
    /// Convert the BinaryInteger value to UInt128 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt128(exactly: value)`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128Exact() -> UInt128? { .init(exactly: self) }

    /// Convert the BinaryInteger value to Float, same as calling `Float(value)`.
    @inlinable public func toFloat() -> Float { .init(self) }
    /// Convert the BinaryInteger value to Float if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Float(exactly: value)`.
    @inlinable public func toFloatExact() -> Float? { .init(exactly: self) }

    /// Convert the BinaryInteger value to Float16, same as calling `Float16(value)`.
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    @inlinable public func toFloat16() -> Float16 { .init(self) }
    /// Convert the BinaryInteger value to Float16 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Float16(exactly: value)`.
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    @inlinable public func toFloat16Exact() -> Float16? { .init(exactly: self) }

    /// Convert the BinaryInteger value to Float32, same as calling `Float32(value)`.
    @inlinable public func toFloat32() -> Float32 { .init(self) }
    /// Convert the BinaryInteger value to Float32 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Float32(exactly: value)`.
    @inlinable public func toFloat32Exact() -> Float32? { .init(exactly: self) }

    /// Convert the BinaryInteger value to Float64, same as calling `Float64(value)`.
    @inlinable public func toFloat64() -> Float64 { .init(self) }
    /// Convert the BinaryInteger value to Float64 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Float64(exactly: value)`.
    @inlinable public func toFloat64Exact() -> Float64? { .init(exactly: self) }

    /// Convert the BinaryInteger value to Double, same as calling `Double(value)`.
    @inlinable public func toDouble() -> Double { .init(self) }
    /// Convert the BinaryInteger value to Double if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Double(exactly: value)`.
    @inlinable public func toDoubleExact() -> Double? { .init(exactly: self) }

}



extension BinaryFloatingPoint {

    /// Convert the BinaryFloatingPoint value to Int, same as calling `Int(value)`.
    @inlinable public func toInt() -> Int { .init(self) }
    /// Convert the BinaryFloatingPoint value to Int using the specified rounding rule
    /// 
    /// Same as calling `Int(value.rounded(rule))`.
    @inlinable public func toInt(_ rule: FloatingPointRoundingRule) -> Int { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to Int if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Int(exactly: value)`.
    @inlinable public func toIntExact() -> Int? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to Int using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `Int(exactly: value.rounded(rule))`.
    @inlinable public func toIntExact(_ rule: FloatingPointRoundingRule) -> Int? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to Int8, same as calling `Int8(value)`.
    @inlinable public func toInt8() -> Int8 { .init(self) }
    /// Convert the BinaryFloatingPoint value to Int8 using the specified rounding rule
    /// 
    /// Same as calling `Int8(value.rounded(rule))`.
    @inlinable public func toInt8(_ rule: FloatingPointRoundingRule) -> Int8 { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to Int8 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Int8(exactly: value)`.
    @inlinable public func toInt8Exact() -> Int8? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to Int8 using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `Int8(exactly: value.rounded(rule))`.
    @inlinable public func toInt8Exact(_ rule: FloatingPointRoundingRule) -> Int8? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to Int16, same as calling `Int16(value)`.
    @inlinable public func toInt16() -> Int16 { .init(self) }
    /// Convert the BinaryFloatingPoint value to Int16 using the specified rounding rule
    /// 
    /// Same as calling `Int16(value.rounded(rule))`.
    @inlinable public func toInt16(_ rule: FloatingPointRoundingRule) -> Int16 { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to Int16 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Int16(exactly: value)`.
    @inlinable public func toInt16Exact() -> Int16? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to Int16 using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `Int16(exactly: value.rounded(rule))`.
    @inlinable public func toInt16Exact(_ rule: FloatingPointRoundingRule) -> Int16? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to Int32, same as calling `Int32(value)`.
    @inlinable public func toInt32() -> Int32 { .init(self) }
    /// Convert the BinaryFloatingPoint value to Int32 using the specified rounding rule
    /// 
    /// Same as calling `Int32(value.rounded(rule))`.
    @inlinable public func toInt32(_ rule: FloatingPointRoundingRule) -> Int32 { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to Int32 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Int32(exactly: value)`.
    @inlinable public func toInt32Exact() -> Int32? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to Int32 using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `Int32(exactly: value.rounded(rule))`.
    @inlinable public func toInt32Exact(_ rule: FloatingPointRoundingRule) -> Int32? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to Int64, same as calling `Int64(value)`.
    @inlinable public func toInt64() -> Int64 { .init(self) }
    /// Convert the BinaryFloatingPoint value to Int64 using the specified rounding rule
    /// 
    /// Same as calling `Int64(value.rounded(rule))`.
    @inlinable public func toInt64(_ rule: FloatingPointRoundingRule) -> Int64 { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to Int64 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Int64(exactly: value)`.
    @inlinable public func toInt64Exact() -> Int64? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to Int64 using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `Int64(exactly: value.rounded(rule))`.
    @inlinable public func toInt64Exact(_ rule: FloatingPointRoundingRule) -> Int64? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to Int128, same as calling `Int128(value)`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128() -> Int128 { .init(self) }
    /// Convert the BinaryFloatingPoint value to Int128 using the specified rounding rule
    /// 
    /// Same as calling `Int128(value.rounded(rule))`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128(_ rule: FloatingPointRoundingRule) -> Int128 { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to Int128 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Int128(exactly: value)`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128Exact() -> Int128? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to Int128 using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `Int128(exactly: value.rounded(rule))`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toInt128Exact(_ rule: FloatingPointRoundingRule) -> Int128? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to UInt, same as calling `UInt(value)`.
    @inlinable public func toUInt() -> UInt { .init(self) }
    /// Convert the BinaryFloatingPoint value to UInt using the specified rounding rule
    /// 
    /// Same as calling `UInt(value.rounded(rule))`.
    @inlinable public func toUInt(_ rule: FloatingPointRoundingRule) -> UInt { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to UInt if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt(exactly: value)`.
    @inlinable public func toUIntExact() -> UInt? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to UInt using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `UInt(exactly: value.rounded(rule))`.
    @inlinable public func toUIntExact(_ rule: FloatingPointRoundingRule) -> UInt? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to UInt8, same as calling `UInt8(value)`.
    @inlinable public func toUInt8() -> UInt8 { .init(self) }
    /// Convert the BinaryFloatingPoint value to UInt8 using the specified rounding rule
    /// 
    /// Same as calling `UInt8(value.rounded(rule))`.
    @inlinable public func toUInt8(_ rule: FloatingPointRoundingRule) -> UInt8 { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to UInt8 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt8(exactly: value)`.
    @inlinable public func toUInt8Exact() -> UInt8? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to UInt8 using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `UInt8(exactly: value.rounded(rule))`.
    @inlinable public func toUInt8Exact(_ rule: FloatingPointRoundingRule) -> UInt8? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to UInt16, same as calling `UInt16(value)`.
    @inlinable public func toUInt16() -> UInt16 { .init(self) }
    /// Convert the BinaryFloatingPoint value to UInt16 using the specified rounding rule
    /// 
    /// Same as calling `UInt16(value.rounded(rule))`.
    @inlinable public func toUInt16(_ rule: FloatingPointRoundingRule) -> UInt16 { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to UInt16 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt16(exactly: value)`.
    @inlinable public func toUInt16Exact() -> UInt16? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to UInt16 using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `UInt16(exactly: value.rounded(rule))`.
    @inlinable public func toUInt16Exact(_ rule: FloatingPointRoundingRule) -> UInt16? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to UInt32, same as calling `UInt32(value)`.
    @inlinable public func toUInt32() -> UInt32 { .init(self) }
    /// Convert the BinaryFloatingPoint value to UInt32 using the specified rounding rule
    /// 
    /// Same as calling `UInt32(value.rounded(rule))`.
    @inlinable public func toUInt32(_ rule: FloatingPointRoundingRule) -> UInt32 { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to UInt32 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt32(exactly: value)`.
    @inlinable public func toUInt32Exact() -> UInt32? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to UInt32 using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `UInt32(exactly: value.rounded(rule))`.
    @inlinable public func toUInt32Exact(_ rule: FloatingPointRoundingRule) -> UInt32? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to UInt64, same as calling `UInt64(value)`.
    @inlinable public func toUInt64() -> UInt64 { .init(self) }
    /// Convert the BinaryFloatingPoint value to UInt64 using the specified rounding rule
    /// 
    /// Same as calling `UInt64(value.rounded(rule))`.
    @inlinable public func toUInt64(_ rule: FloatingPointRoundingRule) -> UInt64 { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to UInt64 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt64(exactly: value)`.
    @inlinable public func toUInt64Exact() -> UInt64? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to UInt64 using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `UInt64(exactly: value.rounded(rule))`.
    @inlinable public func toUInt64Exact(_ rule: FloatingPointRoundingRule) -> UInt64? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to UInt128, same as calling `UInt128(value)`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128() -> UInt128 { .init(self) }
    /// Convert the BinaryFloatingPoint value to UInt128 using the specified rounding rule
    /// 
    /// Same as calling `UInt128(value.rounded(rule))`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128(_ rule: FloatingPointRoundingRule) -> UInt128 { .init(self.rounded(rule)) }
    /// Convert the BinaryFloatingPoint value to UInt128 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `UInt128(exactly: value)`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128Exact() -> UInt128? { .init(exactly: self) }
    /// Convert the BinaryFloatingPoint value to UInt128 using the specified rounding rule if it can be represented exactly
    /// 
    /// Same as calling `UInt128(exactly: value.rounded(rule))`.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    @inlinable public func toUInt128Exact(_ rule: FloatingPointRoundingRule) -> UInt128? { .init(exactly: self.rounded(rule)) }

    /// Convert the BinaryFloatingPoint value to Float, same as calling `Float(value)`.
    @inlinable public func toFloat() -> Float { .init(self) }
    /// Convert the BinaryFloatingPoint value to Float if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Float(exactly: value)`.
    @inlinable public func toFloatExact() -> Float? { .init(exactly: self) }

    /// Convert the BinaryFloatingPoint value to Float16, same as calling `Float16(value)`.
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    @inlinable public func toFloat16() -> Float16 { .init(self) }
    /// Convert the BinaryFloatingPoint value to Float16 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Float16(exactly: value)`.
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    @inlinable public func toFloat16Exact() -> Float16? { .init(exactly: self) }

    /// Convert the BinaryFloatingPoint value to Float32, same as calling `Float32(value)`.
    @inlinable public func toFloat32() -> Float32 { .init(self) }
    /// Convert the BinaryFloatingPoint value to Float32 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Float32(exactly: value)`.
    @inlinable public func toFloat32Exact() -> Float32? { .init(exactly: self) }

    /// Convert the BinaryFloatingPoint value to Float64, same as calling `Float64(value)`.
    @inlinable public func toFloat64() -> Float64 { .init(self) }
    /// Convert the BinaryFloatingPoint value to Float64 if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Float64(exactly: value)`.
    @inlinable public func toFloat64Exact() -> Float64? { .init(exactly: self) }

    /// Convert the BinaryFloatingPoint value to Double, same as calling `Double(value)`.
    @inlinable public func toDouble() -> Double { .init(self) }
    /// Convert the BinaryFloatingPoint value to Double if it can be represented exactly, otherwise returns nil
    /// 
    /// Same as calling `Double(exactly: value)`.
    @inlinable public func toDoubleExact() -> Double? { .init(exactly: self) }

}
