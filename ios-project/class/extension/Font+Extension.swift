//
//  Font+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/22.
//

import Foundation
import UIKit

extension UIFont {
    
    class func system(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size)
    }
    
    class func semibold(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .semibold)
    }
    
    class func bold(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .bold)
    }
    
    class func medium(_ size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .medium)
    }
    
    class func roboto(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size) ?? .system(size)
    }
    
    class func roboto_medium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size) ?? .medium(size)
    }
    
    class func roboto_bold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size) ?? .bold(size)
    }
    
    class func roboto_bold_Italic(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-BoldItalic", size: size) ?? .bold(size)
    }
    
}
