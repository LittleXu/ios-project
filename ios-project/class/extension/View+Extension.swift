//
//  View+Extension.swift
//  ios-project
//
//  Created by liuxu on 2025/1/13.
//

import Foundation
import Toast_Swift
import UIKit
import SwiftUI
import SnapKit


// 红点
extension UIView {
    var badge: UIView? {
        set {
            objc_setAssociatedObject(self, BadgeRuntimeKey.key!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, BadgeRuntimeKey.key!) as? UIActivityIndicatorView
        }
    }
    
    private struct BadgeRuntimeKey {
        static let key = UnsafeRawPointer.init(bitPattern: "UIViewExtension_Badge".hashValue)
    }
    
    @discardableResult
    func showBadge(with color: UIColor = Color.systemRed, size: CGFloat = 8, offset: CGPoint = .zero) -> UIView {
        
        if let badge = badge {
            badge.removeFromSuperview()
        }
        let badge = UIView().bgColor(color).cornerRadius(size / 2)
        addSubview(badge)
        
        badge.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: size, height: size))
            make.right.equalToSuperview().offset(size / 2 + offset.x)
            make.top.equalToSuperview().offset(-size / 2 + offset.y)
        }
        
        self.badge = badge
        return badge
    }
    
    func hideBadge() {
        guard let badge = badge else {
            return
        }
        badge.isHidden = true
    }
}

// loading
extension UIView {
    func showLoading() {
        self.makeToastActivity(.center)
    }
    
    func hideLoading() {
        self.hideToastActivity()
    }
    
    func showToast(_ text: String?) {
        guard let text = text, text.isNotEmpty else { return }
        self.makeToast(text, position: .center)
    }
}


// grandient
extension UIView {
    struct GradientDirectionPoint {
        var startPoint: CGPoint!
        var endPoint: CGPoint!
    }
    
    enum GradientDirection {
        case vertical               // 竖直
        case horizonal              // 水平
        case leftop2rightbottom     // 左上到右下
        case leftbottom2rightop     // 左下到右上
        
        func points() -> [CGPoint] {
            var results = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1)]
            switch self {
            case .vertical:
                results = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1)]
                break
            case .horizonal:
                results =  [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)]
                break
            case .leftop2rightbottom:
                results =  [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1)]
                break
            case .leftbottom2rightop:
                results = [CGPoint(x: 0, y: 1), CGPoint(x: 1, y: 0)]
                break
            }
            return results
        }
    }
    
    @discardableResult
    func addGradient(_ direction: GradientDirection, locations: [NSNumber] = [NSNumber(value: 0), NSNumber(value: 1)], colors: [UIColor], addToSuperView: Bool = true) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.startPoint = direction.points().first!
        layer.endPoint = direction.points().last!
        layer.colors = colors.map({ color in
            return color.cgColor
        })
        layer.locations = locations
        layer.frame = self.bounds
        if addToSuperView {
            self.layer.insertSublayer(layer, at: 0)
        }
        return layer
    }
}


extension UIView {
    
    /// 边框
    func makeBorder(_ width: CGFloat = pixel, borderColor: UIColor = Color.border1) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = width
    }
    
    /// 部分圆角
    func corner(corners: UIRectCorner, radius: CGFloat) {
        let rounded = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.frame = bounds
        shape.path = rounded.cgPath
        layer.mask = shape
    }
    
    
    
    struct ShadowConfig {
        var color: UIColor
        var radius: CGFloat
        var offset: CGSize
        var opacity: CGFloat
    }
    
    @discardableResult
    func makeBottomShadow(color: UIColor = Color.shadow, radius: CGFloat = 0, offset: CGSize = CGSize(width: 0, height: 0), opacity: CGFloat = 0.1) -> UIView {
        let shadow: UIView = UIView()
        shadow.backgroundColor = Color.background
        shadow.layer.shadowColor = color.cgColor
        shadow.layer.cornerRadius = radius
        shadow.layer.shadowOffset = offset
        shadow.layer.shadowRadius = radius
        shadow.layer.shadowOpacity = Float(opacity)
        shadow.clipsToBounds = false
        self.superview?.insertSubview(shadow, belowSubview: self)
        shadow.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        return shadow
    }
    
    func makeShadow(color: UIColor = Color.shadow, radius: CGFloat = 0, offset: CGSize = CGSize(width: 0, height: 3), opacity: CGFloat = 1) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = Float(opacity)
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}


enum CommonViewPosition {
    case left
    case right
    case top
    case bottom
}

// MARK: - Spearator
extension UIView {
    @discardableResult
    func makeSeperator(position: CommonViewPosition = .top, edge: UIEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), separatorColor: UIColor = Color.separator) -> UIView {
        let separator = UIView()
            .bgColor(separatorColor)
        addSubview(separator)
        
        switch position {
        case .left:
            separator.snp.makeConstraints { make in
                make.width.equalTo(pixel)
                make.left.equalTo(edge.left)
                make.top.equalTo(edge.top)
                make.bottom.equalTo(-edge.bottom)
            }
        case .right:
            separator.snp.makeConstraints { make in
                make.width.equalTo(pixel)
                make.right.equalTo(-edge.right)
                make.top.equalTo(edge.top)
                make.bottom.equalTo(-edge.bottom)
            }
        case .top:
            separator.snp.makeConstraints { make in
                make.height.equalTo(pixel)
                make.left.equalTo(edge.left)
                make.right.equalTo(-edge.right)
                make.top.equalTo(edge.top)
            }
        case .bottom:
            separator.snp.makeConstraints { make in
                make.height.equalTo(pixel)
                make.left.equalTo(edge.left)
                make.right.equalTo(-edge.right)
                make.bottom.equalTo(-edge.bottom)
            }
        }
        return separator
    }
}

// MARK: - shake
extension UIView {
    
    func shake(offset: CGFloat = 5) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-offset, offset, -offset, offset, -offset/2, offset/2, -offset/4, offset/4, offset/4 ]
        layer.add(animation, forKey: "shake")
    }
}


// MARK: - loading
// 在view上加一个activityIndicator

extension UIView {
    
    var activityIndicator: UIActivityIndicatorView? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.key!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, RuntimeKey.key!) as? UIActivityIndicatorView
        }
    }
    
    private struct RuntimeKey {
        static let key = UnsafeRawPointer.init(bitPattern: "UIViewExtension_ActivityIndicator".hashValue)
    }
    
    @discardableResult
    func showLoadingIndicator(with backgroundColor: UIColor = Color.background) -> UIView {
        
        hideLoadingIndicator()
        
        let view = UIView(frame: self.bounds).bgColor(backgroundColor)
        
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.frame = view.bounds
        view.addSubview(indicator)
        indicator.startAnimating()
        addSubview(view)
        self.activityIndicator = indicator
        return indicator
    }
    
    func hideLoadingIndicator() {
        guard let activityIndicator = activityIndicator else {
            return
        }
        activityIndicator.stopAnimating()
        activityIndicator.superview?.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        self.activityIndicator = nil
    }
}


extension UIView {
    func appendSubviews(with subviews: [UIView]) {
        _ = subviews.map { subview in
            self.addSubview(subview)
        }
    }
}
