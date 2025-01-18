//
//  DashView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/6.
//

import Foundation
import UIKit

class DashView: UIView {
    
    private var lineLength: CGFloat = 4
    private var lineSpacing: CGFloat = 4
    var strokeColor: UIColor = Color.separator
    private var fillColor: UIColor = .clear
    private var direction: CommonViewDirection = .vertical
    
    
    private var shapeLayer: CAShapeLayer?
    // 直接传入frame 或者 等待布局完成后 调用draw方法 Color.separator
    convenience init(_ frame: CGRect = CGRect.zero, lineLength: CGFloat = 4, lineSpacing: CGFloat = 4, strokeColor: UIColor = Color.separator, fillColor: UIColor = .clear, direction: CommonViewDirection = .vertical) {
        self.init(frame: frame)
        self.lineLength = lineLength
        self.lineSpacing = lineSpacing
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.direction = direction
        
        draw()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.draw()
    }

    func redraw(strokeColor: UIColor = Color.separator) {
        self.strokeColor = strokeColor
        draw()
    }
    
    func draw() {
        if self.frame == .zero { return }
        if let shapeLayer = shapeLayer {
            if shapeLayer.frame == self.bounds {
                return
            } else {
                shapeLayer.removeFromSuperlayer()
                self.shapeLayer = nil
            }
        }
        
        let isHorizontal = direction == .horizontal
        
        shapeLayer = CAShapeLayer()
        shapeLayer?.frame = self.bounds
        shapeLayer?.fillColor = fillColor.cgColor
        shapeLayer?.strokeColor = strokeColor.cgColor
        shapeLayer?.lineWidth = isHorizontal ? self.height : self.width
        shapeLayer?.lineJoin = .round
        shapeLayer?.lineDashPattern = [lineLength.asNumber(), lineSpacing.asNumber()]
        
        // 设置路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: isHorizontal ? self.width : 0, y: isHorizontal ? 0 : self.height))
        shapeLayer?.path = path
        self.layer.addSublayer(shapeLayer!)
    }
    
}


extension UIView {
    // 虚线边框 (必须先设置好frame)
    func makeDashBorder(strokeColor: UIColor = Color.border, fillColor: UIColor = Color.background, cornerRadius: CGFloat = 10, borderWidth: CGFloat = 1, lineDashPattern: [NSNumber] = [4.asNumber(), 2.asNumber()]) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = fillColor.cgColor
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        shapeLayer.path = path.cgPath
        shapeLayer.frame = bounds
        shapeLayer.lineWidth = borderWidth
        shapeLayer.lineDashPattern = lineDashPattern
        layer.addSublayer(shapeLayer)
    }
    
}
