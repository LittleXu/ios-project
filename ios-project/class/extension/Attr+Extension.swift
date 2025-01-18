//
//  Attr+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/1.
//

import Foundation
import UIKit

extension ATTRM {
    
    func changeTextColor(_ text: String, color: UIColor) {
        if let range = self.string.nsRange(of: text) {
            addAttributes([.foregroundColor: color], range: range)
        }
    }
    
    func changeTextFont(_ text: String, font: UIFont) {
        if let range = self.string.nsRange(of: text) {
            addAttributes([.font: font], range: range)
        }
    }
    
    func changeTextAttributes(_ text: String, attributes:[ATTR.Key : Any]) {
        if let range = self.string.nsRange(of: text) {
            addAttributes(attributes, range: range)
        }
    }
    
    func changeRangeAttributes(_ range: NSRange, attributes:[ATTR.Key : Any]) {
        addAttributes(attributes, range: range)
    }
}


extension String {
    
    func nsRange(of string: String) -> NSRange? {
        if let range = self.range(of: string) {
            return NSRange(range, in: self)
        }
        return nil
    }
    
    func toATTRM(with attributes: [ATTR.Key: Any]? = nil) -> ATTRM {
        return ATTRM(string: self, attributes: attributes)
    }
    
    func toATTR(with attributes: [ATTR.Key: Any]? = nil) -> ATTR {
        return ATTR(string: self, attributes: attributes)
    }
}

extension ATTR {
    func toATTRM() -> ATTRM {
        return self.mutableCopy() as? ATTRM ?? self.string.toATTRM()
    }
}

extension ATTRM {
    func toATTR() -> ATTR {
        return self.copy() as? ATTR ?? self.string.toATTR()
    }
}
