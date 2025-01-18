//
//  BaseTipTextField.swift
//  ForexSwift
//
//  Created by liuxu on 2022/5/26.
//  底部带有提示的输入框

import Foundation
import UIKit


class BaseTipTextField: BaseView {
    
    var didEndEndingBlock: B1<String>?
    
    var field: UITextField!
    var tipLabel: UILabel!
    
    convenience init() {
        self.init(frame: .zero)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        field = UITextField()
        field.borderStyle = .none
        field.textColor = Color.text
        field.font = .roboto_bold(21)
        
        let leftView = EdgeLabel()
            .text("$ ")
            .textColor(Color.text)
            .font(.roboto_bold(21))
            .sizeToFit(true)
        
        leftView.frame = CGRect(x: 0, y: 0, width: leftView.frame.width, height: 35)
        field.leftView = leftView
        field.leftViewMode = .always
        field.delegate = self
        addSubview(field)
        
        tipLabel = UILabel()
            .textColor(Color.subText)
            .font(.system(12))
            .numOfLines(0)
            .sizeToFit(true)
        addSubview(tipLabel)
        
        field.snp.makeConstraints { make in
            make.height.equalTo(35)
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(field.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
        
        makeSeperator(position: .top, edge: UIEdgeInsets(top: 35 + 12, left: 15, bottom: 0, right: 15), separatorColor: Color.separator)
        
    }
    
}


extension BaseTipTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        Common.isValid(with: textField, shouldChangeCharactersIn: range, replacement: string, decimalNumber: 2)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEndingBlock?(textField.text ?? "")
    }
}

