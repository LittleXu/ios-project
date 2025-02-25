//
//  CocoaTextField.swift
//  CocoaTextField
//
//  Created by Edgar Žigis on 10/10/2019.
//  Copyright © 2019 Edgar Žigis. All rights reserved.
//

import UIKit

@IBDesignable
public class CocoaTextField: UITextField {
    
    //  MARK: - Open variables -
    
    /**
     * Sets hint color for not focused state
     */
    @IBInspectable
    open var inactiveHintColor = UIColor.gray {
        didSet { configureHint() }
    }
    
    /**
     * Sets hint color for focused state
     */
    @IBInspectable
    open var activeHintColor = UIColor.cyan
    
    /**
     * Sets background color for not focused state
     */
    @IBInspectable
    open var defaultBackgroundColor = UIColor.lightGray.withAlphaComponent(0.8) {
        didSet { backgroundColor = defaultBackgroundColor }
    }
    
    /**
    * Sets background color for focused state
    */
    @IBInspectable
    open var focusedBackgroundColor = UIColor.lightGray
    
    /**
    * Sets border color
    */
    @IBInspectable
    open var borderColor = UIColor.lightGray {
        didSet { layer.borderColor = borderColor.cgColor }
    }
    
    /**
    * Sets border width
    */
    @IBInspectable
    open var borderWidth: CGFloat = 1.0 {
        didSet { layer.borderWidth = borderWidth }
    }
    
    /**
    * Sets corner radius
    */
    @IBInspectable
    open var cornerRadius: CGFloat = 11 {
        didSet { layer.cornerRadius = cornerRadius }
    }
    
    /**
    * Sets error color
    */
    @IBInspectable
    open var errorColor = UIColor.red {
        didSet { errorLabel.textColor = errorColor }
    }
    
    override open var placeholder: String? {
        set { hintLabel.text = newValue }
        get { return hintLabel.text }
    }
    
    public override var text: String? {
        didSet {
            DispatchQueue.main.async {
                self.updateHint()
            }
        }
    }
    
    private var isHintVisible = false
    private let hintLabel = UILabel().sizeToFit(true)
    private let errorLabel = UILabel()
    
    private let padding: CGFloat = 15
    private let hintFont = UIFont.systemFont(ofSize: 11)
    private let hintLargeFont = UIFont.systemFont(ofSize: 14)
    private var initialBoundsWereCalculated = false
    
    var hintOnBorder = false
    var margin: CGFloat = 0
    
    public override var backgroundColor: UIColor? {
        didSet {
//            self.hintLabel.backgroundColor = backgroundColor
        }
    }
    
    //  MARK: Public
    
    public func setError(errorString: String) {
        UIView.animate(withDuration: 0.4) {
            self.errorLabel.alpha = 1
        }
        errorLabel.text = errorString
        updateErrorLabelPosition()
        errorLabel.shake(offset: 10)
        self.bringSubviewToFront(hintLabel)
    }
    
    //  MARK: Private
    
    private func initializeTextField() {
        configureTextField()
        configureHint()
        configureErrorLabel()
        addObservers()
    }
    
    private func addObservers() {
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func configureTextField() {
        clearButtonMode = .whileEditing
        autocorrectionType = .no
        spellCheckingType = .no
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        addSubview(hintLabel)
    }
    
    private func configureHint() {
        hintLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.updateHint()
        hintLabel.textColor = inactiveHintColor
    }

     func updateHint() {
        if isHintVisible {
            // Small placeholder
            self.hintLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y:  hintOnBorder ? -self.height / 2 : -self.hintHeight())
            self.hintLabel.font = self.hintFont
            self.handleHintLabelFrame()
        } else if self.text?.isEmpty ?? true {
            // Large placeholder
            self.handleHintLabelFrame(hintLargeFont)
            self.hintLabel.font = self.hintLargeFont
            self.hintLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
        } else {
            // No placeholder
            self.hintLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: hintOnBorder ? -self.height / 2 : -self.hintHeight())
            self.hintLabel.font = self.hintFont
            self.handleHintLabelFrame()
        }
    }
    
    private func handleHintLabelFrame(_ font: UIFont? = nil) {
        if !self.hintOnBorder { return }
        let font = font ?? hintLabel.font
        let frame = self.hintLabel.frame
        let width = Int(((hintLabel.text ?? "") as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: frame.height), options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil).size.width) + 1
        self.hintLabel.frame = CGRect(x: frame.x, y: frame.y, width: CGFloat(width), height: frame.height)
    }
    
    private func configureErrorLabel() {
        errorLabel.font = UIFont.systemFont(ofSize: 12)
        errorLabel.textAlignment = .right
        errorLabel.textColor = errorColor
        errorLabel.alpha = 0
        addSubview(errorLabel)
    }
    
    func activateTextField() {
        if isHintVisible { return }
        isHintVisible.toggle()
        
        UIView.animate(withDuration: 0.2) {
            self.updateHint()
            self.hintLabel.textColor = self.activeHintColor
            self.backgroundColor = self.focusedBackgroundColor
//            if self.errorLabel.alpha == 0 {
//                self.layer.borderColor = self.focusedBackgroundColor.cgColor
//            }
        }
    }
    
    func deactivateTextField() {
        if !isHintVisible { return }
        isHintVisible.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.updateHint()
            self.hintLabel.textColor = self.inactiveHintColor
            self.backgroundColor = self.defaultBackgroundColor
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    private func hintHeight() -> CGFloat {
        return hintFont.lineHeight - padding / 8
    }
    
    private func updateErrorLabelPosition() {
        let size = errorLabel.sizeThatFits(CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        errorLabel.frame.size = size
        errorLabel.frame.origin.x = frame.width - size.width
        errorLabel.frame.origin.y = frame.height + padding / 4
    }
    
    @objc private func textFieldDidChange() {
        UIView.animate(withDuration: 0.2) {
            self.errorLabel.alpha = 0
//            self.layer.borderColor = self.focusedBackgroundColor.cgColor
        }
    }
    
    //  MARK: UIKit methods
    
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        activateTextField()
        return super.becomeFirstResponder()
    }

    @discardableResult
    override open func resignFirstResponder() -> Bool {
        deactivateTextField()
        return super.resignFirstResponder()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        let rect = CGRect(
            x: padding,
            y: hintHeight() + margin, // - padding / 8, //superRect.origin.y,
            width: superRect.size.width - padding * 1.5,
            height: superRect.size.height - hintHeight() //superRect.size.height
        )
        return rect
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        let rect = CGRect(
            x: padding,
            y: hintHeight() + margin, // - padding / 8,
            width: superRect.size.width - padding * 1.5,
            height: superRect.size.height - hintHeight()
        )
        return rect
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override open func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.clearButtonRect(forBounds: bounds)
        return superRect.offsetBy(dx: -padding / 2, dy: 0)
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width, height: 64)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if !initialBoundsWereCalculated {
            let width = Int(((hintLabel.text ?? "") as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: frame.height), options: .usesLineFragmentOrigin, attributes: [.font: hintLabel.font as Any], context: nil).size.width) + 1
            hintLabel.frame = CGRect(
                origin: CGPoint(x: self.padding, y: 0),
                size: CGSize(width: hintOnBorder ? CGFloat(width) : frame.width - padding * 3, height: frame.height)
            )
            initialBoundsWereCalculated = true
        }
    }
    
    //  MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeTextField()
    }
}
