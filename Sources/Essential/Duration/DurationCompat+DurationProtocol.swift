//
//  File.swift
//  
//
//  Created by Star_Lord_PHB on 2024/6/9.
//

import Foundation


extension DurationCompat: DurationProtocol {
    
    public static func == (lhs: DurationCompat, rhs: DurationCompat) -> Bool {
        lhs.high == rhs.high && lhs.low == rhs.low
    }
    
    
    public static func / (lhs: DurationCompat, rhs: Int) -> DurationCompat {
        lhs.div(rhs.int64Val).quotient
    }
    
    
    func div(
        _ rhs: Int64
    ) -> (quotient: DurationCompat, remainer: DurationCompat) {
        precondition(rhs != 0, "divide by zero")
        var remainer = abs(self)
        var quotient = DurationCompat.zero
        let divisor = DurationCompat(high: 0, low: abs(rhs).uInt64Val)
        for i in stride(from: 127, through: 0, by: -1) {
            quotient = quotient << 1
            if (remainer >> i) >= divisor {
                remainer -= (divisor << i)
                quotient += .init(high: 0, low: 1)
            }
        }
        if (self.high < 0 && rhs > 0) || (self.high > 0 && rhs < 0) {
            quotient = -quotient
            remainer = -remainer
        }
        return (quotient, remainer)
    }
    
    
    public static func * (lhs: DurationCompat, rhs: Int) -> DurationCompat {
        mult(lhs: lhs, rhs: rhs.int64Val)
    }
    
    
    private static func mult(lhs: DurationCompat, rhs: Int64)  -> DurationCompat {
        
        let a96 = lhs.high >> 32
        let b64 = (lhs.high & 0x00000000FFFFFFFF).uInt64Val
        let c32 = lhs.low >> 32
        let d = lhs.low & 0x00000000FFFFFFFF
        
        let e32 = rhs >> 32
        let f = (rhs & 0x00000000FFFFFFFF).uInt64Val
        
        let a96e32 = a96 * e32
        
        // trigger overflow error
        // if a96e32 != 0 && a96e32 != -1 { let _ = a96.int32Val * e32.int32Val }
        
        let a96f = a96 * f.int64Val
        let b64e32 = b64.int64Val * e32
        
        let b64f = b64 * f
        let c32e32 = c32.int64Val * e32
        
        let c32f = c32 * f
        let de32 = d.int64Val * e32
        
        let df = d * f
        
        let comp = df & 0x00000000FFFFFFFF
        let overflow = df >> 32
        
        let comp32Temp = Int64(bitPattern: c32f) + de32 + Int64(bitPattern: overflow)
        let comp32 = comp32Temp << 32
        let overflow32 = UInt64(bitPattern: comp32Temp) >> 32
        
        let comp64Temp = Int64(bitPattern: b64f) + c32e32 + Int64(bitPattern: overflow32)
        let comp64 = comp64Temp & 0x00000000FFFFFFFF
        let overflow64 = UInt64(bitPattern: comp64Temp) >> 32
        
        let comp96Temp = a96f + b64e32 + Int64(bitPattern: overflow64)
        let comp96 = comp96Temp << 32
        let overflow96 = comp96Temp >> 32
        
        let comp128Temp = a96e32 + overflow96
        let comp128 = Int32(truncatingIfNeeded: comp128Temp)
        
        // trigger overflow error
        if comp128 != 0 && comp128 != -1 { let _ = Int32(comp128Temp) }
        
        return .init(high: comp96 + comp64, low: UInt64(bitPattern: comp32) + comp)
        
    }
    
    
    public static func / (lhs: DurationCompat, rhs: DurationCompat) -> Double {
        let lhsDouble = lhs.high.doubleVal * (2 ** 64) + lhs.low.doubleVal
        let rhsDouble = rhs.high.doubleVal * (2 ** 64) + rhs.low.doubleVal
        return lhsDouble / rhsDouble
    }
    
    
    public static let zero: DurationCompat = .init(high: 0, low: 0)
    
    
    public static func + (lhs: DurationCompat, rhs: DurationCompat) -> DurationCompat {
        let (attoseconds, overflow) = lhs.low.addingReportingOverflow(rhs.low)
        let seconds = lhs.high + rhs.high + (overflow ? 1 : 0)
        return DurationCompat(high: seconds, low: attoseconds)
    }
    
    
    public static func - (lhs: DurationCompat, rhs: DurationCompat) -> DurationCompat {
        let (attoseconds, borrow) = lhs.low.subtractingReportingOverflow(rhs.low)
        let seconds = lhs.high - rhs.high - (borrow ? 1 : 0)
        return DurationCompat(high: seconds, low: attoseconds)
    }
    
    
    public static func < (lhs: DurationCompat, rhs: DurationCompat) -> Bool {
        lhs.high < rhs.high || (lhs.high == rhs.high && lhs.low < rhs.low)
    }
    
    
    fileprivate static func << (lhs: DurationCompat, rhs: Int) -> DurationCompat {
        if rhs == 0 { return lhs }
        if rhs >= 128 { return .zero }
        if rhs >= 64 {
            return .init(high: Int64(bitPattern: lhs.low << (rhs - 64)), low: 0)
        }
        return .init(
            high: (lhs.high << rhs) | Int64(bitPattern: lhs.low >> (64 - rhs)),
            low: lhs.low << rhs
        )
    }
    
    
    fileprivate static func >> (lhs: DurationCompat, rhs: Int) -> DurationCompat {
        if rhs == 0 { return lhs }
        if rhs >= 128 { return lhs.high < 0 ? .init(high: -1, low: .max) : .zero }
        if rhs >= 64 {
            return .init(high: lhs.high >> 64, low: UInt64(bitPattern: lhs.high >> (rhs - 64)))
        }
        return .init(
            high: lhs.high >> rhs,
            low: (lhs.low >> rhs) | UInt64(bitPattern: lhs.high << (64 - rhs))
        )
    }
    
    
    public static prefix func - (_ operand: DurationCompat) -> DurationCompat {
        .init(high: ~operand.high, low: ~operand.low) + .init(high: 0, low: 1)
    }
    
}


private func abs(_ timeDuration: DurationCompat) -> DurationCompat {
    timeDuration < .zero ? -timeDuration : timeDuration
}
