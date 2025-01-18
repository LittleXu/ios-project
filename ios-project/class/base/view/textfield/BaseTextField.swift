//
//  BaseTextField.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/22.
//

import Foundation
import RxCocoa
import IQKeyboardManagerSwift
import IQKeyboardCore

extension Common {
    
    @MainActor static func textField() -> CocoaTextField {
        let field = CocoaTextField()
        field.font = .roboto(14)
        field.textColor = Color.text
        field.layer.cornerRadius = 6
        field.inactiveHintColor = Color.subText
        field.activeHintColor = Color.text
        field.focusedBackgroundColor = Color.background
        field.defaultBackgroundColor = Color.background
        field.borderColor = Color.border
        field.errorColor = Color.error
        field.iq.resignOnTouchOutsideMode = IQEnableMode.enabled
        return field
    }
    
    
    @MainActor static func passwordTextField() -> CocoaTextField {
        let field = Common.textField()
        field.isSecureTextEntry = true
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 56))
        
        let button = UIButton(frame: CGRect(x: 0, y: 16, width: 24, height: 24))
        button.setImage(UIImage(named: "icon_eye_open"), for: .normal)
        button.setImage(UIImage(named: "icon_eye_close"), for: .selected)
        button.isSelected = true
        button.addAction { sender in
            sender.isSelected = !sender.isSelected
            field.isSecureTextEntry = sender.isSelected
        }
        rightView.addSubview(button)
        
        field.rightView = rightView
        field.rightViewMode = .always
        
        return field
    }
}

