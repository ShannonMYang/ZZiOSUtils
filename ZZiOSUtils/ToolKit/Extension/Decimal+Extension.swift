//
//  Decimal+Ex.swift
//  PictureLive
//
//  Created by Qi on 2021/3/8.
//

import Foundation

public extension String {
    //整数价格，增加尾0，2位
    func addTailWithRoundNumber() -> String {
//        let priceStr = "\(NSDecimalNumber(decimal: self))"
        let priceStr = self
        if !priceStr.contains(subStr: ".") {
            return priceStr + ".00"
        }
        let subStrs = priceStr.components(separatedBy: ".")
        if let subStr = subStrs.last {
            if subStr.count == 1 {
                return priceStr + "0"
            } else if subStrs.count == 2 {
                return priceStr
            }
        }
        return priceStr

    }
}

public extension Decimal {
    // 除以12，并保留2位小数点，四舍五入
    func divide12keep2DecimalString() -> String {
        return "\(divide12keep2Decimal())"
    }

    func divide12keep2Decimal() -> NSDecimalNumber {
        let behavior2 = calculateBehavior(scale: 2)
        return NSDecimalNumber(decimal: self).dividing(by: NSDecimalNumber(value: 12), withBehavior: behavior2)
    }
}

// scale: 保留小数位数
public func calculateBehavior(scale: Int16) -> NSDecimalNumberHandler {
    return NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.bankers, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
}
