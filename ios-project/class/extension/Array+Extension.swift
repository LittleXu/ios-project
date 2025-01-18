//
//  Array+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/23.
//

import Foundation
import UIKit
import SnapKit

extension Array {
    var isNotEmpty: Bool {
        get {
            return !isEmpty
        }
    }
}

enum CommonViewDirection {
    case horizontal
    case vertical
}

extension Array where Element: UIView {
    func layout(_ direction: CommonViewDirection, before: ConstraintItem, leading: CGFloat, center: ConstraintItem, margin: CGFloat, after: ConstraintItem, trailing: CGFloat) {
        var before = before
        
        if direction == .horizontal {
            for index in 0 ..< count {
                let view = self[index]
                view.snp.makeConstraints { make in
                    make.left.equalTo(before).offset(index == 0 ? leading : margin)
                    make.centerY.equalTo(center)
                    if index == count - 1 {
                        make.right.equalTo(after).offset(-trailing)
                    }
                    
                    if view.frame.size == CGSize.zero {
                        view.sizeToFit()
                    }
                    make.size.equalTo(view.frame.size)
                }
                before = view.snp.right
            }
        } else {
            for index in 0 ..< count {
                let view = self[index]
                view.snp.makeConstraints { make in
                    make.top.equalTo(before).offset(index == 0 ? leading : margin)
                    make.centerX.equalTo(center)
                    if index == count - 1 {
                        make.bottom.equalTo(after).offset(-trailing)
                    }
                    
                    if view.frame.size == CGSize.zero {
                        view.sizeToFit()
                    }
                    make.size.equalTo(view.frame.size)
                }
                before = view.snp.bottom
            }
        }
    }
}
