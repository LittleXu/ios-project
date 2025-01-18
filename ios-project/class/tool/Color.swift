//
//  Color.swift
//  ios-project
//
//  Created by liuxu on 2025/1/13.
//

import Foundation
import UIKit


struct Color {
    
    static var shared = Color()

    /// 0xFFFFFF
    static let background       = 0xFFFFFF.asUIColor()
    /// 0xF6F6F6
    static let lightBackground  = 0xF6F6F6.asUIColor()
    /// 0xF8FAFC
    static let lightBackground1  = 0xF8FAFC.asUIColor()
    /// 0xD8D8D8
    static let darkBackground   = 0xD8D8D8.asUIColor()
    /// 0x3C78D8
    static let theme            = 0x3C78D8.asUIColor()
    /// 0x6675BD
    static let lightTheme       = 0x6675BD.asUIColor()
    /// 0xDCDFED
    static let disable          = 0xDCDFED.asUIColor()
    /// 0xFFFFFF
    static let themeText        = 0xFFFFFF.asUIColor()
    /// 0x201F21
    static let text             = 0x201F21.asUIColor()
    /// 0x999999
    static let subText          = 0x999999.asUIColor()
    /// 0xFF7615
    static let orangeText       = 0xFF7615.asUIColor()
    /// 0xFF801
    static let orangeText1      = 0xFF801F.asUIColor()
    /// 0xFF9500 橙色背景色
    static let orangeText2      = 0xFF9500.asUIColor()
    /// 0xDDE5E4
    static let shadow           = 0xDDE5E4.asUIColor()
    /// 0xE9EEFF
    static let cellShadow       = 0xE9EEFF.asUIColor()
    /// 0xEEEEEE 0.6
    static let cellShadow1      = 0xEEEEEE.asUIColor().withAlphaComponent(0.6)
    /// 0xEDEDED
    static let border           = 0xEDEDED.asUIColor()
    /// 0xF5F6F8
    static let border1          = 0xF5F6F8.asUIColor()
    /// 0xE9EDF7
    static let border2          = 0xE9EDF7.asUIColor()
    /// 0xDB3E5C
    static let error            = 0xDB3E5C.asUIColor()
    /// 0xEDEDED 分割线颜色
    static let separator        = 0xEDEDED.asUIColor()
    
    /// 0x00B18D 绿色
    static let systemGreen      = 0x00B18D.asUIColor()
    /// 0xDB3E5C 红色
    static let systemRed        = error
    /// 蓝色 0x0180F3
    static let systemBlue       = 0x0180F3.asUIColor()
    
    /// 0xE6F7F4 浅绿背景色
    static let systemLightGreen = 0xE6F7F4.asUIColor()
    /// 0xFFE7EB 浅红背景色
    static let systemLightRed   = 0xFFE7EB.asUIColor()
    /// 浅蓝背景色
    static let systemLightBlue  = systemBlue.withAlphaComponent(0.5)

}


