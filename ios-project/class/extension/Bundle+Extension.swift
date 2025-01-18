//
//  Bundle+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/16.
//

import Foundation
import UIKit

extension Bundle {
    
    var appName: String? {
        return infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var releaseVersionNumberPretty: String {
        return "v\(releaseVersionNumber ?? "1.0.0")"
    }
    
    var appIcon: UIImage? {
        if let imageName = (((infoDictionary?["CFBundleIcons"] as? [String: Any])?["CFBundlePrimaryIcon"] as? [String: Any])?["CFBundleIconFiles"] as? [Any])?.last as? String {
            return UIImage(named: imageName)
        }
        return nil
    }
}



private struct BundleRuntimeKey {
    static let key = UnsafeRawPointer.init(bitPattern: "BundleEx".hashValue)!
}

class BundleEx: Bundle {
        
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let bundle = objc_getAssociatedObject(self, BundleRuntimeKey.key) as? Bundle else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

// MARK: - Language
extension Bundle {
    
    class func exchange() {
        object_setClass(Bundle.main, BundleEx.self)
    }
    
    class func set(language: String) {
        exchange()
        if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
            if let value = Bundle(path: path) {
                objc_setAssociatedObject(Bundle.main, BundleRuntimeKey.key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
