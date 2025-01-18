//
//  Common.swift
//  ios-project
//
//  Created by liuxu on 2025/1/13.
//

import Foundation
import UIKit
import Log
import ObjectMapper
import Photos

fileprivate let LOG = Logger()

typealias B = ()->Void
typealias B1<T> = (T)->Void
typealias B2<T1, T2> = (T1, T2)->Void
typealias B3<T1, T2, T3> = (T1, T2, T3)->Void

typealias ATTR = NSAttributedString
typealias ATTRM = NSMutableAttributedString
typealias PARA = NSMutableParagraphStyle



extension Common {
    
   static func saveImage(_ image: UIImage?) {
        guard let image = image else { return }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            if success {
                DispatchQueue.main.async {
                    Common.currentViewController()?.view.showToast("图片保存成功!")
                }
            } else {
                if let error = error {
                    DispatchQueue.main.async {
                        Common.currentViewController()?.view.showToast(error.localizedDescription)
                    }
                }
            }
        }
    }
}




extension Common {
    static func isSimulator() -> Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }
}

struct Common {
    
    static func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegex, options: .caseInsensitive)
            let range = NSRange(location: 0, length: email.count)
            let matches = regex.matches(in: email, options: [], range: range)
            return !matches.isEmpty
        } catch {
            return false
        }
    }
    
    static func validatePwd(_ pwd: String) -> Bool {
        let pwdRegex = "[\\dA-Za-z~!/@#$%^&*()\\-_=+|\\[{}\\];:'\",<.>?]{8,24}$"
        do {
            let regex = try NSRegularExpression(pattern: pwdRegex, options: .caseInsensitive)
            let range = NSRange(location: 0, length: pwd.count)
            let matches = regex.matches(in: pwd, options: [], range: range)
            return !matches.isEmpty
        } catch {
            return false
        }
    }
}


extension Common {
    
    /// 限制 textfield 只能输入小数 和 小数点 并且只能有一个小数点
    /// 在 shouldChangeCharactersIn 中 调用该方法
    static func amountInput(textField: UITextField, range: NSRange, replacement: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: replacement)
        // 检查是否只包含数字和小数点
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        let characterSet = CharacterSet(charactersIn: updatedText)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        // 检查小数点的数量
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        let decimalCount = updatedText.components(separatedBy: decimalSeparator).count - 1
        if decimalCount > 1 {
            return false
        }
        return true
    }
}

extension Common {
    /// 复制到粘贴板
    static func copyText(_ text: String?) {
        guard let text = text else { return }
        let pb = UIPasteboard.general
        pb.string = text
        showToast("已复制到粘贴板!")
    }
}

extension Common {
    static func currentViewController() -> UIViewController? {
        var current: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while current != nil {
            let vc = current!
            if let tabbarvc = vc as? UITabBarController {
                current = tabbarvc.selectedViewController
            } else if let navc = vc as? UINavigationController {
                current = navc.topViewController
            }
//            else if let presented = current?.presentedViewController {
//                current = presented
//            }
            else if let split = vc as? UISplitViewController, split.viewControllers.count > 0 {
                current = split.viewControllers.last
            } else {
                return current
            }
        }
        return current
    }
    
    static func push(_ vc: UIViewController, animated: Bool = true) {
        currentViewController()?.push(vc, animated: animated)
    }
    
    static func pushNewOrPopExist<T: UIViewController>(target: T, animated: Bool = true) {
        guard let current = currentViewController() else { return }
        if let vcs = current.navigationController?.viewControllers {
            let result = vcs.filter { controller in
                return controller.isKind(of: T.self)
            }
            
            if let popTarget = result.first {
                current.navigationController?.popToViewController(popTarget, animated: animated)
                return
            }
        }
        push(target)
    }
}


extension Common {
    static func showLoading() {
        UIApplication.shared.keyWindow?.makeToastActivity(.center)
    }
    
    static func hideLoading() {
        UIApplication.shared.keyWindow?.hideToastActivity()
    }
    
    static func showToast(_ string: String?) {
        UIApplication.shared.keyWindow?.makeToast(string, position: .center)
    }
}

extension Common {
    /// 拉起系统的分享
    static func systemshare(_ items: [Any], on vc: UIViewController?) {
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activity.completionWithItemsHandler = { type, completed, items, error in }
        if let vc = vc {
            vc.present(activity, animated: true)
        } else {
            currentViewController()?.present(activity, animated: true)
        }
    }
}


extension Common {
    static func cropping(image: UIImage, rect: CGRect) -> UIImage {
        var newRect = rect
        newRect.origin.x *= image.scale
        newRect.origin.y *= image.scale
        newRect.size.width *= image.scale
        newRect.size.height *= image.scale
        let cgimage = image.cgImage?.cropping(to: newRect)
        let resultImage = UIImage(cgImage: cgimage!, scale: image.scale, orientation: image.imageOrientation)
        return resultImage
    }
    
}

extension Common {
    
    // 打开网页
    static func openWeb(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        openWeb(url)
    }
    
    static func openWeb(_ url: URL) {
        let vc = WebViewController(url: url, title: "")
        vc.hidesBottomBarWhenPushed = true
        Common.push(vc)
    }
    
    static func openLocalHtml(_ url: URL) {
        let vc = WebViewController(localHtmlUrl: url, title: "")
        vc.hidesBottomBarWhenPushed = true
        Common.push(vc)
    }
    
    static func open(_ urlstring: String) {
        if let url = URL(string: urlstring) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}



struct CommonAlertActionModel {
    var title = ""
    var style = UIAlertAction.Style.default
    var handler: B1<UIAlertAction>?
    
    static func cancel(_ title: String = "取消", handler: B1<UIAlertAction>? = nil) -> Self {
        return CommonAlertActionModel(title: title, style: .cancel, handler: handler)
    }
    
    static func iknow(_ title: String = "我知道了", handler: B1<UIAlertAction>? = nil) -> Self {
        return CommonAlertActionModel(title: title, style: .default, handler: handler)
    }
    
    static func confirm(_ title: String = "确认", handler: B1<UIAlertAction>? = nil) -> Self {
        return CommonAlertActionModel(title: title, style: .default, handler: handler)
    }
    
    func alertAction() -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: handler)
    }
}

// Alert
extension Common {
    @discardableResult
    static func showAlert(_ title: String = "", message: String = "", actions: [CommonAlertActionModel], on viewcontroller: UIViewController? = nil, other: B1<UIAlertController>? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action.alertAction())
        }
        other?(alert)
        if let vc = viewcontroller ?? currentViewController() {
            vc.present(alert, animated: true)
        }
        return alert
    }
}

// DatePicker
extension Common {
    static func showDatePicker(_ title: String, mode: UIDatePicker.Mode, date: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, dateChanged: B1<Date>?, sureAction: B?) {
        let alert = UIAlertController(style: .actionSheet, title: title)
        alert.addDatePicker(mode: mode, date: date, minimumDate: minimumDate, maximumDate: maximumDate) { date in
            dateChanged?(date)
        }
        alert.addAction(title: "确认", style: .default) { action in
            sureAction?()
        }
        alert.show()
    }
    
    static func showPickerView(_ title: String, values: PickerViewViewController.Values, action: PickerViewViewController.Action?, sureAction: B?) -> UIPickerView {
        let alert = UIAlertController(style: .actionSheet, title: title)
        let picker = alert.addPickerView(values: values, action: action)
        alert.addAction(title: "确认", style: .default) { action in
            sureAction?()
        }
        alert.show()
        return picker
    }
}



extension Common {
    /// 初始化日志框架
    static func initLog() {
#if DEBUG
        ios_project.LOG.minLevel = .trace
#else
        ios_project.LOG.minLevel = .warning
#endif
        LOG(.trace, "LOG START TRACE")
        LOG(.debug, "LOG START DEBUG")
        LOG(.info, "LOG START INFO")
        LOG(.warning, "LOG START WARNING")
        LOG(.error, "LOG START ERROR")
    }
    
    static func LOG(_ level: Level, _ items: Any...) {
        var prefirx = "💙"
        switch level {
        case .trace:
            break
        case .debug:
            prefirx = "💜"
        case .info:
            prefirx = "💚"
        case .warning:
            prefirx = "💛"
        case .error:
            prefirx = "❤️"
        @unknown default:
            break
        }
        
        let items = "\(prefirx) \(items)"
        switch level {
        case .trace:
            ios_project.LOG.trace(items)
        case .debug:
            ios_project.LOG.debug(items)
        case .info:
            ios_project.LOG.info(items)
        case .warning:
            ios_project.LOG.warning(items)
        case .error:
            ios_project.LOG.error(items)
        @unknown default:
            break
        }
    }
}


extension Common {
    static func attr(_ string: String, textColor: UIColor = Color.text, font: UIFont = .system(14), align: NSTextAlignment = .center, spacing: CGFloat = 3) -> ATTR {
        let para = PARA()
        para.alignment = align
        para.lineSpacing = spacing
        
        return ATTR(string: string, attributes: [.font: font, .foregroundColor: textColor, .paragraphStyle: para])
    }
    
    
    static func attrm(_ string: String, textColor: UIColor = Color.text, font: UIFont = .system(14), align: NSTextAlignment = .center, spacing: CGFloat = 3) -> ATTRM {
        let para = PARA()
        para.alignment = align
        para.lineSpacing = spacing
        
        return ATTRM(string: string, attributes: [.font: font, .foregroundColor: textColor, .paragraphStyle: para])
    }
}

import Alamofire
// 网络监听
extension Common {
    /// 监听网络状态变化
    static func startListening() {
        let network = NetworkReachabilityManager()
        network?.startListening(onUpdatePerforming: { status in
//            NotificationKeys.reachability.post()
        })
    }
}


/// 日期格式
extension Common {
    /// 日期格式
    static func dateFormatter(_ format: String = "yyyy-MM-dd HH:mm:ss") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = format
        return formatter
    }
}


/// 对象地址
extension Common {
    
    // 取出某个对象的地址
    static func memoryAddress(object: AnyObject) -> String {
        let str = Unmanaged<AnyObject>.passUnretained(object).toOpaque()
        return String(describing: str)
    }
    
    // 对比两个对象的地址是否相同
    static func ismemoryAddressSame(_ object1: AnyObject, _ object2: AnyObject) -> Bool {
        let str1 = memoryAddress(object: object1)
        let str2 = memoryAddress(object: object2)
       return str1 == str2
    }
}

/// 生成系统快照
extension Common {
    static func customSnapshot(from view: UIView) -> UIView? {
        if let snapshot = view.snapshotView(afterScreenUpdates: true) {
            snapshot.layer.masksToBounds = true
            snapshot.layer.cornerRadius = 0
            snapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
            snapshot.layer.shadowRadius = 5
            snapshot.layer.shadowOpacity = 0.4
            return snapshot
        }
        return nil
    }
}

/// 交换数据对象

extension Common {
    static func exchange<T>(array: inout [T], index0: Int, index1: Int) {
        (array[index0], array[index1]) = (array[index1], array[index0])
    }
}


/// window
extension Common {
    static func makeToastActivityInWindow() {
        UIApplication.shared.keyWindow?.makeToastActivity(.center)
    }
    
    static func hideToastActivityInWindow() {
        UIApplication.shared.keyWindow?.hideToastActivity()
    }
    
    static func makeToastInWindow(_ string: String) {
        UIApplication.shared.keyWindow?.showToast(string)
    }
}



import CoreImage
/// QRCODE
extension Common {
    
    static func qrcode(with url: String) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator", parameters: nil) else { return nil }
        guard let data = url.data(using: .utf8) else { return nil }
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        guard let image = filter.outputImage else { return nil }
        // 高清处理
        return Common.createHDImage(with: image, size: 200)
    }
    
    static func createHDImage(with image: CIImage, size: CGFloat) -> UIImage {
        let extent = image.extent.integral
        let scale = min(size / extent.width, size / extent.height)
        
        let width: size_t = size_t(extent.width * scale)
        let height: size_t = size_t(extent.height * scale)
        let cs: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmap: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 1)!
        
        ///
        let context = CIContext.init()
        let bitmapImage = context.createCGImage(image, from: extent)
        bitmap.interpolationQuality = .none
        bitmap.scaleBy(x: scale, y: scale)
        bitmap.draw(bitmapImage!, in: extent)
        
        let scaledImage = bitmap.makeImage()
        return UIImage.init(cgImage: scaledImage!)
        
    }
    
}

extension Common {
    
    static func numberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }
    
    static func currency(_ string: String, emptyReplace: String = "--", symbol: String = "$") -> String {
        if string.isEmpty { return emptyReplace }
        let numberFormatter = numberFormatter()
        numberFormatter.currencySymbol = symbol
        return numberFormatter.string(from: NSDecimalNumber(string: string)) ?? ""
    }
    
    /// 输入框中只能输入数字和小数点, 且小数点只能输入1个
    /// - Parameters:
    ///   - textfield: textfield
    ///   - range: range
    ///   - replacementString: replacementString
    ///   - decimal: 小数位
    static func isValid(with textfield: UITextField, shouldChangeCharactersIn range: NSRange, replacement string: String, decimalNumber number: Int) -> Bool {
        // 如果小数位为0 则不能输入小数点
        if number <= 0 && string == "." { return false }
        // 第一位是小数点
        if (textfield.text?.isEmpty ?? true) && string == "." {
            textfield.text = "0."
            textfield.sendActions(for: .editingChanged)
            return false
        }
        var numbers: CharacterSet = []
        let scanner = Scanner(string: string)
        let pointRange = textfield.text?.nsRange(of: ".")
        if let pointRange = pointRange, pointRange.length > 0, (pointRange.location < range.location || pointRange.location > range.location + range.length) {
            numbers = CharacterSet(charactersIn: "0123456789")
        } else {
            numbers = CharacterSet(charactersIn: "0123456789.")
        }
        
        let remain = number
        let tempString = (textfield.text ?? "") + string
        let strlen = tempString.length
        
        if let pointRange = pointRange, pointRange.length > 0, pointRange.location > 0 {
            if string == "." { return false }   // 如果已经有. 再次输入.时无效
            if strlen > 0 && strlen - pointRange.location > remain + 1 { return false } // 如果小数位超出限制位数, 无效
        }
        
        let zeroRange = textfield.text?.nsRange(of: "0")
        if let zeroRange = zeroRange, zeroRange.length == 1, zeroRange.location == 0 {
            if textfield.text?.length == 1 && string != "0" && string != "." {
                textfield.text = string
                textfield.sendActions(for: .editingChanged)
                return false
            } else {
                // 如果没有小数点,再次输入0的话 则无效
                if nil == pointRange, string == "0" { return false }
            }
        }
        
        var buffer: NSString?
        if !scanner.scanCharacters(from: numbers, into: &buffer) && string.isNotEmpty {
            return false
        }
        return true
    }
    
    /// 检测是否是有效的步长数据
    static func isValidStepValue(_ value: String, tickSize: String) -> Bool {
        if tickSize.isEmpty || tickSize.floatValue == 0 { return true }
        if value.isEmpty { return false }
        let string = value.operation(.division, value: tickSize)
        let scan = Scanner(string: string)
        var val: Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
}



import MessageUI
// 发送邮件

extension Common {
    
    class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {
        weak var current: UIViewController?
        override init() {}
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            // 关闭
            current?.dismiss(animated: true)
            if result == .sent {
                Common.showToast("成功!")
            } else if result == .failed {
                Common.showToast(error?.localizedDescription ?? "")
            }
        }
    }
    
    static let mailDelegate = MailDelegate()
    
    static func sendEmail(with email: String) {
        
        if !MFMailComposeViewController.canSendMail() {
            Common.showToast("Email service is not activited")
            return;
        }
        
        let vc = MFMailComposeViewController()
        vc.setToRecipients([email])
        vc.mailComposeDelegate = mailDelegate
        Common.currentViewController()?.present(vc, animated: true)
    }
    
}


extension Common {
    
    static func call(with mobile: String) {
        let string = "tel://" + mobile
        if let url = URL(string: string) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
}


