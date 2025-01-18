//
//  CommonTitleFieldView.swift
//  FutureWallet
//
//  Created by liuxu on 2023/6/7.
//  UT提现页面输入框

import Foundation
import UIKit

class CommonTitleFieldView: BaseView {
    
    var titleLabel: UILabel!
    var textField: UITextField!
    var textFieldTappedBlock: B?
    var isAmount = false
    var isLetter = false
    var isUpperCase = false
    var lenthLimit = 0
    convenience init(title: String, placeholder: String, rightView: UIView? = nil, isAmount: Bool = false) {
        self.init(frame: .zero)
        self.isAmount = isAmount
        bgColor(Color.lightBackground1)
        
        titleLabel = UILabel()
            .text(title)
            .textColor(Color.text)
            .font(.roboto_medium(16))
        
        textField = UITextField().bgColor(.white).cornerRadius(6)
        textField.borderStyle = .none
        textField.makeBorder(1, borderColor: Color.border)
        textField.font = .roboto(14)
        textField.attributedPlaceholder = placeholder.toATTR(with: [.foregroundColor: Color.subText])
        textField.delegate = self
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 56))
        textField.rightView = rightView ?? UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 56))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        appendSubviews(with: [titleLabel, textField])
        
        // layout
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(56)
            make.bottom.equalToSuperview()
        }
    }
}

extension CommonTitleFieldView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if isLetter {
            textField.isSecureTextEntry = true
        }
        
        if let block = textFieldTappedBlock {
            block()
            return false
        }
        textField.layer.borderColor = Color.text.cgColor
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isLetter {
            textField.isSecureTextEntry = false
            textField.autocapitalizationType = .allCharacters
            textField.autocorrectionType = .yes
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = Color.border.cgColor
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isAmount {
            return Common.amountInput(textField: textField, range: range, replacement: string)
        }
        
        if isLetter {
            // 获取要输入的新字符串
            var newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            // 检查新字符串是否仅包含大写字母
            if !Common.isValidLetterAndSpace(with: newString) {
                return false // 如果包含非大写字母，则禁止输入
            }
            
            newString = Common.handleMultipleSpace(with: newString)
           
            if lenthLimit > 0, newString.length > lenthLimit {
                newString = String(newString.prefix(lenthLimit))
            }
            
            // 转成大写
            if isUpperCase {
                textField.text = newString.uppercased()
            } else {
                textField.text = newString
            }
            
            return false

        }
        return true
    }
}

extension Common {
    
    static func isValidLetterAndSpace(with input: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z ]*$")
        return regex.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) != nil
    }
    
    static func handleMultipleSpace(with input: String) -> String {
        let strings = input.components(separatedBy: .whitespaces)
        var result = strings.filter {$0.isNotEmpty}
        var resultString =  result.joined(separator: " ")
        if !resultString.hasSuffix(" ") && strings.last == "" {
            resultString += " "
        }
        return resultString
    }
    
}


