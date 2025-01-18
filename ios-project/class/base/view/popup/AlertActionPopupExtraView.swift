//
//  AlertActionPopupExtraView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/6/16.
//

import Foundation
import UIKit

class AlertActionPopupExtraView: BasePopupView {
    
    class func attributes() -> [ATTR.Key: Any] {
        let para = Common.textPara()
        para.alignment = .center
        
        return [.foregroundColor: Color.text, .font: UIFont.system(14), .paragraphStyle: para]
    }
    
    private var title = ""
    private var contentAttr = ATTR()
    private var actions: [AlertActionModel] = []
    
    private var container: UIView!
    private var titleL: UILabel!
    private var contentL: UILabel!
    private var actionButtons: [UIButton] = []
    
    private var extraView: UIView!
    
    convenience init(_ title: String = "", contentAttr: ATTR, extraView: UIView, actions: [AlertActionModel] = []) {
        self.init()
        self.title = title
        self.contentAttr = contentAttr
        self.extraView = extraView
        self.actions = actions
        setupViews()
    }
    
    private func setupViews() {
        container = UIView()
            .bgColor(Color.background)
            .cornerRadius(15)
        addSubview(container)
        
        titleL = UILabel()
            .text(title)
            .textColor(Color.text)
            .font(.medium(18))
            .sizeToFit(true)
            .numOfLines(0)
        container.addSubview(titleL)
        
        contentL = UILabel()
            .attributeText(contentAttr)
            .numOfLines(0)
            .sizeToFit(true)
        container.addSubview(contentL)
        
        container.addSubview(extraView)
        
        for model in actions {
            let button = model.button()
            button.action { _ in
                self.dismiss()
                model.block?()
            }
            container.addSubview(button)
            actionButtons.append(button)
        }
        
       
        
        if actions.count == 2 {
            let leftB = actionButtons[0]
            let rightB = actionButtons[1]
            
            let width = (screenWidth * widthAdaptePercent() - 50 - 15) * 0.5
            if leftB.width <= width && rightB.width <= width {
                leftB.snp.makeConstraints { make in
                    make.left.equalTo(25)
                    make.width.equalTo(width)
                    make.top.equalTo(extraView.snp.bottom).offset(25)
                    make.height.equalTo(38)
                    make.bottom.equalTo(-25)
                }
                
                rightB.snp.makeConstraints { make in
                    make.right.equalTo(-25)
                    make.width.height.equalTo(leftB)
                    make.centerY.equalTo(leftB)
                }
            } else {
                _ = actionButtons.map { button in
                    button.width = screenWidth * self.widthAdaptePercent() - 50
                    button.height = 38
                }
                actionButtons.layout(.vertical, before: extraView.snp.bottom, leading: 25, center: container.snp.centerX, margin: 15, after: container.snp.bottom, trailing: 25)
            }
        } else if actions.count > 0 {
            _ = actionButtons.map { button in
                button.width = screenWidth * self.widthAdaptePercent() - 50
                button.height = 38
            }
            actionButtons.layout(.vertical, before: extraView.snp.bottom, leading: 25, center: container.snp.centerX, margin: 15, after: container.snp.bottom, trailing: 25)
        } else {
            extraView.snp.makeConstraints { make in
                make.bottom.equalTo(-25)
            }
        }
            
        // layout
        self.snp.makeConstraints { make in
            make.width.equalTo(screenWidth * widthAdaptePercent())
            make.height.greaterThanOrEqualTo(200)
        }
        
        container.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        titleL.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(15)
            make.top.equalTo(22)
        }
        
        contentL.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(titleL.snp.bottom).offset(22)
        }
        
        extraView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(extraView.frame.size)
            make.top.equalTo(contentL.snp.bottom).offset(22)
        }
    }
    
    
    override func widthAdaptePercent() -> CGFloat {
        return (screenWidth - 50) / screenWidth
    }
    
}
