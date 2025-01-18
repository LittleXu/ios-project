//
//  Extension.swift
//  WallPaperClient
//
//  Created by liuxu on 2021/1/15.
//

import Foundation
import UIKit
import Kingfisher

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
let bottomSafeAreaHeight = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0

let widthScale = screenWidth / 375
let widthScaleLessEqual1 = widthScale >= 1 ? 1 : widthScale

let pixel = 1 / UIScreen.main.scale

extension UIImage {
    /// 更改图片颜色
    public func imageWithTintColor(color : UIColor) -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        color.setFill()
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}

fileprivate typealias viewClick = ((UIView) -> ())


extension UIView {
    func asImage() -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
//        let ctx = UIGraphicsGetCurrentContext()!
//        self.layer.render(in: ctx)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image!
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIView {
    @objc private func viewClickAction() {
        self.viewActionBlock?(self)
    }
    
    private struct RuntimeKey {
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
    }
    
    private var viewActionBlock: viewClick? {
        set {
            objc_setAssociatedObject(self, UIView.RuntimeKey.actionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, UIView.RuntimeKey.actionBlock!) as? viewClick
        }
    }
    
    func addViewAction(handle: @escaping ((UIView) -> ())) {
        self.viewActionBlock = handle
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClickAction))
        self.addGestureRecognizer(tap)
    }
    
}

// MARK: - 闭包处理ImageView点击事件
fileprivate typealias imageClick = ((UIImageView)->())
extension UIImageView {
    @objc private func clickAction() {
        self.actionBlock?(self)
    }
    
    private struct RuntimeKey {
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
    }
    private var actionBlock: imageClick? {
        set {
            objc_setAssociatedObject(self, UIImageView.RuntimeKey.actionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UIImageView.RuntimeKey.actionBlock!) as? imageClick
        }
    }
    
    
    func addAction(handle:@escaping ((UIImageView)->())) {
        self.actionBlock = handle
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickAction))
        self.addGestureRecognizer(tap)
    }
}


extension UIImageView {
    
    func setImageUrl(_ url: String?) {
        guard let url = url else { return }
        kf.setImage(with: URL(string: url))
    }
}

// MARK: - 闭包处理Button点击事件
fileprivate typealias buttonClick = ((UIButton)->())

extension UIButton {
    
    @objc private func clickAction() {
        self.actionBlock?(self)
    }
    
    private struct RuntimeKey {
        static let actionBlock = UnsafeRawPointer.init(bitPattern: "actionBlock".hashValue)
    }
    
    private var actionBlock: buttonClick? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.actionBlock!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, UIButton.RuntimeKey.actionBlock!) as? buttonClick
        }
    }

    
    func addAction(controlEvents: UIControl.Event = .touchUpInside ,handle:@escaping ((UIButton)->())) {
        self.actionBlock = handle
        self.addTarget(self, action: #selector(clickAction), for: controlEvents)
    }
}



extension UIColor {
    //返回随机颜色
    class var random: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    public class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,blue: CGFloat(rgbValue & 0x0000FF) / 255.0,alpha: CGFloat(1.0))
    }
}

extension UITableView {
    /*
     弹出一个静态的cell，无须注册重用，例如:
     let cell: GrayLineTableViewCell = tableView.mm_dequeueStaticCell(indexPath)
     即可返回一个类型为GrayLineTableViewCell的对象
     
     - parameter indexPath: cell对应的indexPath
     - returns: 该indexPath对应的cell
     */
    func mm_dequeueStaticCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        let reuseIdentifier = "staticCellReuseIdentifier - \(indexPath.description)"
        if let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T {
            return cell
        }else {
            let cell = T(style: .default, reuseIdentifier: reuseIdentifier)
            return cell
        }
    }
}

extension Date {
    /// 计算两个时间间隔
    /// - parameter lastDate: 上个时间
    /// - parameter toDate: 目标时间
    /// - returns: 间隔 秒
    static func getSecondFromLastdate(lastDate: Date, toDate: Date) -> Int {
        let calendar = NSCalendar.current
        let date = calendar.dateComponents([.year,.month,.day, .hour, .minute, .second], from: lastDate, to: toDate)
        let sec = date.hour! * 3600 + date.minute! * 60 + date.second!
        return sec
    }
    
    /// 计算两个时间间隔
    /// - parameter lastDate: 上个时间
    /// - parameter toDate: 目标时间
    /// - returns: 间隔 时分秒
    static func getDateIntervalFromLastdate(lastDate: Date, toDate: Date) -> String {
        let calendar = NSCalendar.current
        let date = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: lastDate, to: toDate)
        return "\(date.hour!):\(date.minute!):\(date.second!)"
    }
    
    //计算两个时间差多少年
    static func getSecondFormLastdataYear(lastDate : Date, toDate : Date) -> Int {
        let calendar = NSCalendar.current
        let date = calendar.dateComponents([.year,.month,.day, .hour, .minute, .second], from: lastDate, to: toDate)
        let sec = date.year
        return sec!
    }
}


extension Array {
    
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}

//GCD延时操作
extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}
extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}



extension UILabel {
    convenience init(_ text: String, font: UIFont = 14.plainFont(), color: UIColor = UIColor.black) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = color
        self.numberOfLines = 0
    }
    
    @discardableResult
    func txtAlignment(_ v: NSTextAlignment) -> Self {
        self.textAlignment = v
        return self
    }
    
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    func sizeToFit(_ isSizeToFit: Bool) -> Self {
        if isSizeToFit {
            self.sizeToFit()
        }
        return self
    }
    
    @discardableResult
    func adjust(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }
    
    @discardableResult
    func numOfLines(_ lines: Int) -> Self {
        self.numberOfLines = lines
        return self
    }
    
    @discardableResult
    func attributeText(_ attr: NSAttributedString) -> Self {
        self.attributedText = attr
        return self
    }
}


extension Int {
    func asUIColor() -> UIColor {
        return UIColor(red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat((self & 0x0000FF) >> 0) / 255.0,
                       alpha: 1.0)
    }
    
     //    familyName:PingFang SC
    //PingFangSC-Medium
    //PingFangSC-Semibold
    //PingFangSC-Light
    //PingFangSC-Ultralight
    //PingFangSC-Regular
    // PingFangSC-Thin
    func plainFont() -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: CGFloat(self)) ??
         UIFont.systemFont(ofSize: CGFloat(self))
    }
    
    func bold() -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: CGFloat(self)) ?? UIFont.boldSystemFont(ofSize: CGFloat(self))
    }
}

extension UIColor {
    func asImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 10, height: 10), false, 0.0)
        self.set()
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.addRect(CGRect(x: 0, y: 0, width: 10, height: 10))
        ctx?.fillPath();
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let inset = UIEdgeInsets(top: (image?.size.height)!/4,
                                 left: (image?.size.width)!/4,
                                 bottom: (image?.size.height)!/4,
                                 right: (image?.size.width)!/4)
        return (image?.resizableImage(withCapInsets: inset, resizingMode: UIImage.ResizingMode.stretch))!
    }
    
    class func asColor(r: Float,g: Float,b: Float) -> UIColor {
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(1.0))
    }
    class func asColor(_ rgb: Float) -> UIColor {
        return UIColor(red: CGFloat(rgb/255.0), green: CGFloat(rgb/255.0), blue: CGFloat(rgb/255.0), alpha: CGFloat(1.0))
    }
    
    class func hexColor(_ hexString: String?) -> UIColor {
        guard let hexString = hexString else { return .clear }
        var formattedString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if formattedString.hasPrefix("#") {
            formattedString.remove(at: formattedString.startIndex)
        }
        
        let scanner = Scanner(string: formattedString)
        var color: UInt64 = 0
        if scanner.scanHexInt64(&color) {
            var alpha: CGFloat = 1.0
            var red = CGFloat((color & 0xFF0000) >> 16) / 255.0
            var green = CGFloat((color & 0x00FF00) >> 8) / 255.0
            var blue = CGFloat(color & 0x0000FF) / 255.0
            
            if formattedString.count > 6 {
                alpha = CGFloat((color & 0xFF000000) >> 24) / 255.0
            }
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        return .clear
    }
    
    func hexString() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

extension UIView {

    @discardableResult
    func asChildOf(_ parent: UIView) -> Self {
        parent.addSubview(self)
        return self
    }
    /// 不容易被拉伸
    @discardableResult
    func huggingMore() -> Self {
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return self
    }
    
    /// 容易被拉伸
    @discardableResult
    func huggingLess() -> Self {
        self.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
        return self
    }
    
    /// 不容易被压缩
    @discardableResult
    func compressionMore() -> Self {
        self.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return self
    }
    
    /// 容易被压缩
    @discardableResult
    func compressionLess() -> Self {
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return self
    }
    
    @discardableResult
    func bgColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        return self
    }
    
}









