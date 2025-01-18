//
//  EdgeLabel.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/2.
//

import Foundation
import UIKit
import SwiftUI


class EdgeLabel: UILabel {
    
    
    class func label(_ color: UIColor, text: String) -> EdgeLabel {
        let label = EdgeLabel()
            .text(text)
            .edge(UIEdgeInsets(top: 0, left: 7.5, bottom: 0, right: 7.5))
            .font(.medium(12))
            .txtAlignment(.center)
            .cornerRadius(3)
            .sizeToFit(true)
        label.backgroundColor = color
        return label
    }
    
    
    var edge: UIEdgeInsets = .zero {
        didSet {
            sizeToFit()
        }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        rect.x -= edge.left
        rect.y -= edge.top
        rect.width += (edge.left + edge.right)
        rect.height += (edge.top + edge.bottom)
        return rect
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edge))
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
}


extension EdgeLabel {
    @discardableResult
    func edge(_ edge: UIEdgeInsets) -> Self {
        self.edge = edge
        return self
    }
}
