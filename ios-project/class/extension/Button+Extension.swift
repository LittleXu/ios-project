//
//  Button+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/22.
//

import Foundation
import UIKit

extension UIButton {
    
    /// 创建一个文字带下划线的按钮
    class func underLineTextButton(_ text: String, textColor: UIColor = Color.theme, font: UIFont = .system(12), action:B? = nil) -> UIButton {
        let button = UIButton()
            .normalTitle(text)
            .normalTitleColor(textColor)
            .font(font)
            .sizeToFit(true)
        button.addAction { _ in
            action?()
        }
        
        let attr = text.toATTR(with: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        button.titleLabel?.attributedText = attr
        return button
    }
    
    /// 创建一个无背景色 文字颜色为主题色的按钮
    class func textButton(_ text: String, textColor: UIColor = Color.theme, font: UIFont = .system(12), image: UIImage? = nil, action: B? = nil) -> UIButton {
        let button = UIButton()
            .normalImage(image)
            .normalTitle(text)
            .normalTitleColor(textColor)
            .font(font)
            .sizeToFit(true)
      
        button.addAction { _ in
            action?()
        }
        return button
    }
    
    /// 创建一个有背景色的按钮
    class func colorBackgroundButton(_ text: String, font: UIFont = .roboto(16), cornerRadius: CGFloat = 6, backgroundColor: UIColor = Color.theme, disableBackgroundColor: UIColor = Color.disable, action: B? = nil) -> UIButton {
        let button = UIButton()
            .normalTitle(text)
            .normalTitleColor(Color.themeText)
            .font(font)
        
        button.addAction { _ in
            action?()
        }
        
        button.setBackgroundImage(backgroundColor.asImage(), for: .normal)
        button.setBackgroundImage(disableBackgroundColor.asImage(), for: .disabled)
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        return button
    }
    
    ///  并且带有图标的按钮
    class func button(_ text: String, font: UIFont = .system(16), image: UIImage? = nil, cornerRadius: CGFloat = 21.5, backgroundColor: UIColor = Color.theme, disableBackgroundColor: UIColor = Color.disable, action: B? = nil) -> UIButton {
        let button = UIButton()
            .normalTitle(text)
            .normalTitleColor(Color.themeText)
            .font(font)
        
        button.addAction { _ in
            action?()
        }
        
        if let image = image {
            button.setImage(image, for: .normal)
        }
        
        button.setBackgroundImage(backgroundColor.asImage(), for: .normal)
        button.setBackgroundImage(disableBackgroundColor.asImage(), for: .disabled)
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        return button
    }
    
}


extension UIButton {
    
    @discardableResult
    func normalImage( _ image: UIImage?) -> Self  {
        self.setImage(image, for: .normal)
        return self
    }
    @discardableResult
    func selectedImage( _ image: UIImage?) -> Self {
        self.setImage(image, for: .selected)
        return self
    }
    @discardableResult
    func disabledImage( _ image: UIImage?) -> Self {
        self.setImage(image, for: .disabled)
        return self
    }
    @discardableResult
    func bgImage( _ image: UIImage?) -> Self {
        self.setBackgroundImage(image, for: .normal)
        return self
    }
    @discardableResult
    func normalTitle( _ title: String) -> Self {
        self.setTitle(title, for: .normal)
        return self
    }
    @discardableResult
    func selectedTitle( _ title: String) -> Self {
        self.setTitle(title, for: .selected)
        return self
    }
    @discardableResult
    func normalTitleColor( _ color: UIColor) -> Self {
        self.setTitleColor(color, for: .normal)
        return self
    }
    @discardableResult
    func selectedTitleColor( _ color: UIColor) -> Self {
        self.setTitleColor(color, for: .selected)
        return self
    }
    @discardableResult
    func disabledTitleColor( _ color: UIColor) -> Self {
        self.setTitleColor(color, for: .disabled)
        return self
    }
    @discardableResult
    func font( _ font: UIFont) -> Self {
        self.titleLabel?.font = font
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
    func action(_ action: @escaping B1<UIButton>) -> Self {
        self.addAction(handle: action)
        return self
    }
    
    // MARK: - 倒计时
    public func countDown(count: Int){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        
        // 保存当前的背景颜色
//        let defaultColor = self.backgroundColor
        // 设置倒计时,按钮背景颜色
//        backgroundColor = UIColor.gray
        
        let title = self.title(for: .normal)
        
        var remainingCount: Int = count {
            willSet {
                setTitle("\(newValue)s", for: .normal)
                
                if newValue <= 0 {
                    setTitle(title, for: .normal)
                }
            }
        }
        
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            DispatchQueue.main.async {
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
//                    self.backgroundColor = defaultColor
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    
    func setVisableState(_ enabled: Bool) {
        self.isEnabled = enabled
        self.alpha = enabled ? 1 : 0.8
    }
}



@objc extension UIButton {
    /// Enum to determine the title position with respect to the button image
    ///
    /// - top: title above button image
    /// - bottom: title below button image
    /// - left: title to the left of button image
    /// - right: title to the right of button image
    @objc enum Position: Int {
        case top, bottom, left, right
    }
    
    /// This method sets an image and title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    @objc func set(image: UIImage?, title: String, titlePosition: Position, additionalSpacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        setTitle(title, for: state)
        titleLabel?.contentMode = .center

        adjust(title: title, at: titlePosition, with: additionalSpacing)
        
    }
    
    /// This method sets an image and an attributed title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button attributed title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    @objc func set(image: UIImage?, attributedTitle title: NSAttributedString, at position: Position, width spacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        
        adjust(attributedTitle: title, at: position, with: spacing)
        
        titleLabel?.contentMode = .center
        setAttributedTitle(title, for: state)
    }
    
    
    // MARK: Private Methods
    
    @objc func adjust(at position: Position, with spacing: CGFloat) {
        adjust(title: self.title(for: .normal) ?? "", at: position, with: spacing)
    }
    
    @objc func adjust(title: String, at position: Position, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = (title as NSString).size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    @objc func adjust(attributedTitle: NSAttributedString, at position: Position, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        let titleSize = attributedTitle.size()
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    @objc func adjust(at position: Position, with imageSize: CGSize, with spacing: CGFloat) {
        let title = self.title(for: .normal) ?? ""
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = (title as NSString).size(withAttributes: [NSAttributedString.Key.font: titleFont])
        arrange(titleSize: titleSize, imageRect: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height), atPosition: position, withSpacing: spacing)
    }

    @objc private func arrange(titleSize: CGSize, imageRect:CGRect, atPosition position: Position, withSpacing spacing: CGFloat) {
        switch (position) {
        case .top:
            titleEdgeInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: spacing / 2 + titleSize.height, left: -imageRect.width/2, bottom: 0, right: -imageRect.width/2)
        case .bottom:
            titleEdgeInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: -imageRect.width/2, bottom: spacing / 2 + titleSize.height, right: -imageRect.width/2)
        case .left:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
        case .right:
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing / 2)
        }
    }
}

