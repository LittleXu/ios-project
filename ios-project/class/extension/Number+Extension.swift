//
//  Number+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/31.
//

import Foundation


extension Double {
    /// 10位的时间戳转Date
    func toDate() -> Date {
        return Date(timeIntervalSince1970: self)
    }
}

extension Double {
    func asNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension CGFloat {
    func asNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension Int {
    func asNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}


extension Float {
    func asNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}
