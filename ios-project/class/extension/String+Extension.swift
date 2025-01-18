//
//  String+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/16.
//

import Foundation
import UIKit

// MARK: - Common

extension String {
    
    var isNotEmpty: Bool {
        get {
            return !isEmpty
        }
    }
    
    var length: Int {
        get {
            return count
        }
    }
    
    var doubleValue: Double {
        get  {
            return (self as NSString).doubleValue
        }
    }
    
    var floatValue: Float {
        get {
            return (self as NSString).floatValue
        }
    }
    
    var intValue: Int {
        get {
            return (self as NSString).integerValue
        }
    }
    
    var integerValue: Int {
        get {
            return (self as NSString).integerValue
        }
    }
    
    var boolValue: Bool {
        get {
            return (self as NSString).boolValue
        }
    }
    
    
    func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    func asImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: self))
    }
    
    func sizeFor(maxW: CGFloat,maxH: CGFloat,font: UIFont) -> CGSize {
        let string = NSString(string: self)
        let size = string.boundingRect(with: CGSize(width: maxW , height: maxH),
                                       options: .usesLineFragmentOrigin,
                                       attributes: [.font: font],
                                       context: nil).size
        return size
    }
    
    func setMoneyNubWithType(nuberStyle:NumberFormatter.Style) -> String {
        let formatter = NumberFormatter.init()
        formatter.numberStyle = nuberStyle
        let money = formatter.string(from: NSNumber.init(value: Double(self) ?? 0.00))
        return money!
    }
}


// MARK: -

extension String {
    func base64ToImage() -> UIImage? {
        guard let url = URL(string: self) else { return nil }
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        guard let image = UIImage(data: imageData) else { return nil }
        return image
    }
}

// MARK: - Number


enum CommonOperationType {
    case add
    case reduce
    case multiply
    case division
}


extension String {
    
    func ifEmpty(_ value: String) -> String {
        return self.isEmpty ? value : self
    }
    
}

extension String {
    
    func currency() -> Self {
        return Common.currency(self)
    }
    
    func addSymbol() -> Self {
        if !contains("-") {
            return "+" + self
        }
        return self
    }
    
    func scale(scale: Int = 2) -> Self {
       return self.operation(.add, value: "0", scale: scale)
    }
    
    /// 添加货币符号
    func addMoneySymbol(_ symbol: String = "$") -> Self {
        var string = self
        if string.hasPrefix("-") {
            string.removeFirst()
            string = "-\(symbol)\(string)"
        } else {
            string = "\(symbol)\(string)"
        }
        return string
    }
    
    
    func toDecimalString() -> String {
        guard let value = Double(self) else { return self }
        let doubleString = String(format: "%lf", value)
        let decialNumber = NSDecimalNumber.init(string: doubleString)
        return decialNumber.stringValue
    }
    
    mutating func decimalString() {
        guard let value = Double(self) else { return }
        let doubleString = String(format: "%lf", value)
        let decialNumber =  NSDecimalNumber.init(string: doubleString)
        self = decialNumber.stringValue
    }
    
    /// 运算
    /// - Parameters:
    ///   - type: 运算类型
    ///   - value: 第二个值
    ///   - scale: 小数位
    ///   - mode: 四舍五入方式
    ///   - positiveFormat: 正数情况下前面怎么展示
    func operation(_ type: CommonOperationType, value: String, scale: Int? = nil, mode: NSDecimalNumber.RoundingMode = .plain, positiveFormat: String = "") -> String {
        var value1 = self
        var value2 = value
        
        if type == .division && value.doubleValue == 0 {
            Common.LOG(.error, "除数为0!")
            return "0"
        }
        
        if value1.length == 0 || value1.contains("null") {
            value1 = "0"
        }
        
        if value2.length == 0 || value2.contains("null") {
            value2 = "0"
        }
        
        let number1 = NSDecimalNumber.init(string: value1)
        let number2 = NSDecimalNumber.init(string: value2)
        var result: NSDecimalNumber? = nil
        
        switch type {
        case .add:
            result = number1.adding(number2)
        case .reduce:
            result = number1.subtracting(number2)
        case .multiply:
            result = number1.multiplying(by: number2)
        case .division:
            result = number1.dividing(by: number2)
        }
        
        if let scale = scale {
            let handler = NSDecimalNumberHandler(roundingMode: mode, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
            result = result?.adding(NSDecimalNumber(string: "0"), withBehavior: handler)
        }
        
        if positiveFormat.isNotEmpty {
            let formatter = NumberFormatter._formatter(scale: scale, positiveFormat: positiveFormat)
            return formatter.string(from: result ?? NSDecimalNumber(string: "0")) ?? "0"
        }
        return result?.stringValue ?? "0"
    }
    
    func compare(_ value: String) -> ComparisonResult {
        return NSDecimalNumber(string: self).compare(NSDecimalNumber(string: value))
    }
    
    func isLessThan(_ value: String) -> Bool {
        return self.compare(value) == .orderedAscending
    }
    
    func isGreatThan(_ value: String) -> Bool {
        return self.compare(value) == .orderedDescending
    }
    
    func isEqualTo(_ value: String) -> Bool {
        return self.compare(value) == .orderedSame
    }
    
    func isLessThanOrEqualTo(_ value: String) -> Bool {
        return self.isLessThan(value) || self.isEqualTo(value)
    }
    
    func isGreatThanOrEqualTo(_ value: String) -> Bool {
        return self.isGreatThan(value) || self.isEqualTo(value)
    }
    
    
    func isBetweenIn(_ value1: String, _ value2: String) -> Bool {
        var min = value1
        var max = value2
        
        if !min.isLessThanOrEqualTo(max) {
            let temp = min
            min = max
            max = temp
        }
        
        return self.isGreatThanOrEqualTo(min) && self.isLessThanOrEqualTo(max)
    }
}


extension NumberFormatter {
    
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.numberStyle = .none
        
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.currencyDecimalSeparator = "."
        formatter.currencyGroupingSeparator = ","
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    static func _formatter(scale: Int?, positiveFormat: String) -> NumberFormatter {
        formatter.alwaysShowsDecimalSeparator = scale != 0
        formatter.minimumFractionDigits = scale ?? 10
        formatter.positiveFormat = positiveFormat
        return formatter
    }
}




// MARK: - Attribute
extension String {
    //改变字符串部分字体颜色
    func changeTextChange(regex: [String], color: UIColor) -> NSMutableAttributedString
    {
        let attributeString = NSMutableAttributedString(string: self)
        do {
            for rege in regex {
                let regexExpression = try NSRegularExpression(pattern: rege, options: NSRegularExpression.Options())
                let result = regexExpression.matches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, self.count))
                for item in result {
                    attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: item.range)
                }
            }
        } catch {
            print("Failed with error: \(error)")
        }
        return attributeString
    }
    func changeTextFont(regex: [String], font: UIFont,color: UIColor) -> NSMutableAttributedString
    {
        let attributeString = NSMutableAttributedString(string: self)
        do {
            for rege in regex {
                let regexExpression = try NSRegularExpression(pattern: rege, options: NSRegularExpression.Options())
                let result = regexExpression.matches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, self.count))
                for item in result {
                    attributeString.addAttribute(NSAttributedString.Key.font, value: font, range: item.range)
                    attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: item.range)
                }
            }
        } catch {
            print("Failed with error: \(error)")
        }
        return attributeString
    }
    func changeTexTiltleColor1(color : UIColor? , needHeadIndent : Bool) -> NSMutableAttributedString{
        let finalStr = NSMutableAttributedString(string: self)
        if color != nil{
            var tempStr = self
            var tempLocal = 0
            
            let range = self.range(of: ": ")?.upperBound.encodedOffset
            if range != nil {
                finalStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color!, range: NSMakeRange(0,range!))
                
                for i in self{
                    if i == "\r\n" || i == "\n"{
                        //1.截取字符串的起始位置
                        var strTemp = "\n"
                        if i == "\r\n"{
                            strTemp = "\r\n"
                        }
                        let local1 = tempStr.range(of: strTemp)!.upperBound
                        //2.截取字符串
                        let str1 = tempStr.substring(from: local1)
                        //3.计算长度
                        let length1 = str1.range(of: ": ")!.upperBound.encodedOffset
                        //4.计算位置
                        let location1 = local1.encodedOffset + tempLocal
                        
                        finalStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color!, range: NSMakeRange(location1, length1))
                        
                        tempStr = str1
                        tempLocal = location1
                    }
                }
            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        // 行间距设置为3
        paragraphStyle.lineSpacing = 10
        if needHeadIndent {
            paragraphStyle.firstLineHeadIndent = 17 * 2
        }
        paragraphStyle.paragraphSpacing = 0
        paragraphStyle.alignment = .justified
        
        finalStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.count))
        
        return finalStr
    }
    
    //设置字符串的行间距、段间距
    func setlineSpacing(spacing : CGFloat, ParagraphSpacing : CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        // 行间距设置为3
        paragraphStyle.lineSpacing = spacing
        
        paragraphStyle.paragraphSpacing = ParagraphSpacing
        paragraphStyle.alignment = .justified
        
        let setStr = NSMutableAttributedString.init(string: self)
        setStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.count))
        return setStr
    }
    
    //返回第一次出现的指定子字符串在此字符串中的索引
    func positionOf(sub:String)->Int {
        var pos = -1
        if let range = range(of:sub) {
            if !range.isEmpty {
                pos = distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
    func summaryHeight(contextSize : CGSize, font : CGFloat, space : CGFloat) -> CGFloat {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = .byCharWrapping
        paraStyle.alignment = .left
        paraStyle.lineSpacing = space
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = 0.0
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0
        paraStyle.tailIndent = 0
        let dic = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: font), NSAttributedString.Key.paragraphStyle : paraStyle, NSAttributedString.Key.kern : 0] as [NSAttributedString.Key : Any]
        let summaryRect = self.boundingRect(with: contextSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dic, context: nil)
        return summaryRect.size.height
    }
    
    func stringSize() -> CGSize {
        let size: CGSize = self.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        return size
    }
    
    func asUIImage() -> UIImage {
        return UIImage(named: self) ?? UIImage()
    }
    
}


enum StringValidType: String {
    case number                     = "^[0-9]+$"
    case letter                     = "^[A-Za-z]+$"
    case number_letter              = "^[A-Za-z0-9]+$"
    case letter_space               = "^[A-Za-z\\s]+$"
    case number_letter_space        = "^[A-Za-z0-9\\s]+$"
    case all                        = "^[A-Za-z0-9\\s~`!@#$%^&*()-/+_=|//\\[\\]{};:'\",<.>?\\\\]+$"
}

extension Common {
    static func checkVaild(_ string: String, type: StringValidType) -> Bool {
        if string.isEmpty { return true }
        let predict = NSPredicate(format: "SELF MATCHES %@", string)
        return predict.evaluate(with: string)
    }
}


let ut = "VERTVQ==".base64DecodeThenReversed()
let uc = "Q0RTVQ==".base64DecodeThenReversed()
let crt20 = "MDJDUlQ=".base64DecodeThenReversed()
let cre20 = "MDJDUkU=".base64DecodeThenReversed()


extension String {
    // base64解码 然后倒序
    func base64DecodeThenReversed() -> String {
        let data = Data(base64Encoded: self)!
        var result = String(data: data, encoding: .utf8)!
        result = String(result.reversed())
        return result
    }
    
    //倒序 然后base64编码
    func reversedThenBase64Encode() -> String {
        let reversedString = String(self.reversed())
        // 将颠倒后的字符串进行 Base64 编码
           if let data = reversedString.data(using: .utf8) {
               let encodedString = data.base64EncodedString()
               return encodedString
           } else {
               return ""
           }
    }
}
