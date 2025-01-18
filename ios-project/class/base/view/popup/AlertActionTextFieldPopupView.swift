//
//  AlertActionTextFieldPopupView.swift
//  FutureWallet
//
//  Created by liuxu on 2023/6/13.
//

import Foundation
import UIKit

class AlertTextFieldPopupView: BasePopupView {
    var titleField: CommonTitleFieldView!
    private var titleLabel: UILabel!
    private var cancelButton: UIButton!
    private var confirmButton: UIButton!
    
    
    convenience init(title: String, fieldTitle: String, placeholder: String, isAmount: Bool = false, comfirmBlock: B1<String>?) {
        self.init(frame: .zero)
        
        
        self.bgColor(Color.background).cornerRadius(6)
        
        titleLabel = UILabel()
            .text(title)
            .textColor(Color.text)
            .font(.roboto_medium(16))
            
        titleField = CommonTitleFieldView(title: fieldTitle, placeholder: placeholder, rightView: nil, isAmount: isAmount)
        titleField.bgColor(Color.background)
        
        cancelButton = UIButton.colorBackgroundButton("取消", font: .roboto(16), cornerRadius: 6, backgroundColor: Color.border, disableBackgroundColor: Color.disable, action: { [weak self] in
            self?.dismiss()
        })
        
        confirmButton = UIButton.colorBackgroundButton("确认", action: { [weak self] in
            guard let text = self?.titleField.textField.text else {
                self?.titleField.textField.shake()
                return
            }
            self?.dismiss {
                comfirmBlock?(text)
            }
        })
        
        appendSubviews(with: [titleLabel, titleField, cancelButton, confirmButton])
        
        // layout
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(24)
        }
        
        titleField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.height.equalTo(42)
            make.top.equalTo(titleField.snp.bottom).offset(60)
            make.bottom.equalTo(-24)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.equalTo(cancelButton.snp.right).offset(20)
            make.right.equalTo(-24)
            make.top.height.width.equalTo(cancelButton)
        }
    }
    
    override func widthAdaptePercent() -> CGFloat {
        return (screenWidth - 24) / screenWidth
    }
  
    
}
