//
//  SwitchTextView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/1.
//

import Foundation
import UIKit

class SwitchTextView: BaseView {
    
    enum Position {
        case left
        case right
    }
    
    var switchV: SwitchView!
    var label: UILabel!
    
    convenience init(_ text: String, textColor: UIColor = Color.text, font: UIFont = .system(14), isOn: Bool = false, position: SwitchTextView.Position = .left) {
        self.init()
        
        switchV = SwitchView()
        switchV.isOn = isOn
        addSubview(switchV)
        
        label = UILabel()
            .text(text)
            .textColor(textColor)
            .font(font)
            .sizeToFit(true)
        addSubview(label)
        
        // layout
        if position == .left {
            label.snp.makeConstraints { make in
                make.left.equalTo(0)
                make.top.greaterThanOrEqualTo(0)
                make.bottom.lessThanOrEqualTo(0)
                make.centerY.equalToSuperview()
            }
            
            switchV.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.top.greaterThanOrEqualTo(0)
                make.bottom.lessThanOrEqualTo(0)
                make.centerY.equalToSuperview()
                make.size.equalTo(switchV.frame.size)
                make.left.equalTo(label.snp.right).offset(8)
            }
        } else {
            
            switchV.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.top.greaterThanOrEqualTo(0)
                make.bottom.lessThanOrEqualTo(0)
                make.size.equalTo(switchV.frame.size)
                make.centerY.equalToSuperview()
            }
            
            label.snp.makeConstraints { make in
                make.right.equalTo(0)
                make.left.equalTo(switchV.snp.right).offset(8)
                make.top.greaterThanOrEqualTo(0)
                make.bottom.lessThanOrEqualTo(0)
                make.centerY.equalToSuperview()
            }
        }
        
        
        let size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
}
