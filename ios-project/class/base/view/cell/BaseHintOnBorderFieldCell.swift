//
//  BaseHintOnBorderFieldCell.swift
//  ForexSwift
//
//  Created by liuxu on 2022/6/2.
//

import Foundation
import UIKit
import IQKeyboardCore

struct BaseFieldCellModel {
    var title: String
    var placeholder: String
    var rightText: String?
    var textChangedBlock: B1<String>?
}

class BaseHintOnBorderFieldCell: BaseTableViewCell {
    
    var model: BaseFieldCellModel? {
        didSet {
            guard let model = model else { return }
            
            if let rightText = model.rightText {
                let rightView = EdgeLabel()
                    .edge(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
                    .text(rightText)
                    .textColor(Color.text)
                    .font(.system(14))
                    .sizeToFit(true)
                field.rightView = rightView
                field.rightViewMode = .always
            } else {
                field.rightView = nil
            }
            
            field.placeholder = model.placeholder
            field.text = model.title
        }
    }
    
    var field: CocoaTextField!
    
    private var bottomView: UIView!
    
    func showErrorAndShake(error: String = "") {
        bottomView.layer.borderColor = Color.systemRed.cgColor
        self.field.setError(errorString: error)
        self.field.shake()
    }
    
    override class func rowHeight() -> CGFloat {
        return 56 + 22
    }
    
    override func setupViews() {
        super.setupViews()
        
        field = Common.textField()
        field.hintOnBorder = true
        field.activeHintColor = Color.theme
        field.borderColor = .clear
        field.frame = CGRect(x: 15, y: 11, width: screenWidth - 30, height: 56)
        field.rx.text.orEmpty.subscribe { string in
            self.model?.textChangedBlock?(string)
        }.disposed(by: disposeBag)
        field.iq.resignOnTouchOutsideMode = IQEnableMode.enabled

        
        bottomView = UIView()
        bottomView.layer.cornerRadius = field.layer.cornerRadius
        bottomView.makeBorder(1)
        contentView.addSubview(bottomView)
        
        contentView.addSubview(field)
        
        
        
        field.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(56)
            make.centerY.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.top.equalTo(field).offset(-1)
            make.right.bottom.equalTo(field).offset(1)
        }
    }
    
}
