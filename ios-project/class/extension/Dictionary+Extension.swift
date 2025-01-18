//
//  Dictionary+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/21.
//

import Foundation

extension Dictionary {
    func toJSON() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed) else { return "" }
        let string = String(data: data, encoding: .utf8) ?? ""
        return string
    }
    
    func toEncryptSort() -> String {
        guard !isEmpty else { return "" }
        var paramString = ""
        paramString = self.reduce(into: paramString, {result, dic in
            result += "\(dic.key)=\(dic.value)"
            result += "&"
        })
        
        if paramString.hasSuffix("&") {
            paramString.removeLast()
        }
        return paramString
    }
}

extension Dictionary where Key == String, Value: Any {
    mutating func addIfNotEmpty(key: String, value: Any?) {
        if let value = value {
            if let stringValue = value as? String {
                if stringValue.isNotEmpty {
                    self[key] = stringValue as? Value
                }
            } else {
                self[key] = value as? Value
            }
        }
    }
}
