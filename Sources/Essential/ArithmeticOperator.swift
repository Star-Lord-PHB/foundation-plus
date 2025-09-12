import Foundation


precedencegroup PowerPrecedent {
    associativity: right
    higherThan: MultiplicationPrecedence
    lowerThan: BitwiseShiftPrecedence
}
infix operator ** : PowerPrecedent



public func ** <T: BinaryInteger>(lhs: T, rhs: T) -> Double {
    pow(lhs.toDouble(), rhs.toDouble())
}


public func ** <T: BinaryFloatingPoint>(lhs: T, rhs: T) -> Double {
    pow(lhs.toDouble(), rhs.toDouble())
}


public func ** (lhs: Decimal, rhs: Int) -> Decimal {
    pow(lhs, rhs)
}
