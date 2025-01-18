//
//  AlertActionPopupView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/7.
//  带有按钮的alert弹窗 样式如下
//  https://lanhuapp.com/web/#/item/project/detailDetach?pid=59ff55bb-ef81-48ec-bc58-50125c95bbd9&project_id=59ff55bb-ef81-48ec-bc58-50125c95bbd9&image_id=06437169-5776-4f52-9889-896a67268123&fromEditor=true

import Foundation
import UIKit


enum AlertActionType {
    case cancel         // 取消样式 
    case sure           // 确认样式
}


class AlertActionPopupView: BasePopupView {
    
    class func attributes() -> [ATTR.Key: Any] {
        let para = Common.textPara()
        para.alignment = .left
        
        return [.foregroundColor: Color.text, .font: UIFont.roboto(14), .paragraphStyle: para]
    }
    
    private var title = ""
    private var contentAttr = ATTR()
    private var actions: [AlertActionModel] = []
    
    private var container: UIView!
    private var titleL: UILabel!
    private var contentL: UILabel!
    private var actionButtons: [UIButton] = []
    
    convenience init(_ title: String = "温馨提示", contentAttr: ATTR, actions: [AlertActionModel] = []) {
        self.init()
        self.title = title
        self.contentAttr = contentAttr
        
        let cancelActions = actions.filter { model in
            return model.type == .cancel
        }
        
        let sureActions = actions.filter { model in
            return model.type == .sure
        }
        
        var actions = [AlertActionModel]()
        actions.append(contentsOf: cancelActions)
        actions.append(contentsOf: sureActions)
        self.actions = actions
        setupViews()
    }
    
    func setupViews() {
        container = UIView()
            .bgColor(Color.background)
            .cornerRadius(6)
        addSubview(container)
        
        titleL = UILabel()
            .text(title)
            .textColor(Color.text)
            .font(.roboto_medium(16))
            .sizeToFit(true)
            .huggingMore()
        container.addSubview(titleL)
        
        contentL = UILabel()
            .attributeText(contentAttr)
            .numOfLines(0)
            .sizeToFit(true)
        container.addSubview(contentL)
        
        for model in actions {
            let button = model.button()
            button.action { _ in
                self.dismiss {
                    model.block?()
                }
            }
            container.addSubview(button)
            actionButtons.append(button)
        }
        
       
        
        if actions.count == 2 {
            let leftB = actionButtons[0]
            let rightB = actionButtons[1]
            
            let width = (screenWidth * widthAdaptePercent() - 50 - 20) * 0.5
            if leftB.width <= width && rightB.width <= width {
                leftB.snp.makeConstraints { make in
                    make.left.equalTo(25)
                    make.width.equalTo(width)
                    make.top.equalTo(contentL.snp.bottom).offset(60)
                    make.height.equalTo(42)
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
                    button.height = 42
                }
                actionButtons.layout(.vertical, before: contentL.snp.bottom, leading: 25, center: container.snp.centerX, margin: 20, after: container.snp.bottom, trailing: 25)
            }
        } else if actions.count > 0 {
            _ = actionButtons.map { button in
                button.width = screenWidth * self.widthAdaptePercent() - 50
                button.height = 42
            }
            actionButtons.layout(.vertical, before: contentL.snp.bottom, leading: 25, center: container.snp.centerX, margin: 20, after: container.snp.bottom, trailing: 25)
        } else {
            contentL.snp.makeConstraints { make in
                make.bottom.equalTo(-25)
            }
        }
            
        titleL.isHidden = title.isEmpty
        
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
            make.left.greaterThanOrEqualTo(25)
            make.top.equalTo(24)
        }
        
        if (title.isEmpty) {
            contentL.snp.makeConstraints { make in
                make.left.equalTo(25)
                make.right.equalTo(-25)
                make.top.equalTo(40)
            }
        } else {
            contentL.snp.makeConstraints { make in
                make.left.equalTo(25)
                make.right.equalTo(-25)
                make.top.equalTo(titleL.snp.bottom).offset(40)
            }
        }       
    }
    
    
    override func widthAdaptePercent() -> CGFloat {
        return (screenWidth - 50) / screenWidth
    }
}


struct AlertActionModel {
    var title: String
    var type: AlertActionType
    var block: B?
    
    func button() -> UIButton {
        if type == .cancel {
            let button = UIButton()
                .bgColor(Color.border)
                .normalTitle(title)
                .normalTitleColor(Color.subText)
                .font(.roboto(16))
                .cornerRadius(6)
                .sizeToFit(true)
            return button
            
        } else {
            let button = UIButton()
                .bgColor(Color.theme)
                .normalTitle(title)
                .normalTitleColor(.white)
                .font(.roboto(16))
                .cornerRadius(6)
                .sizeToFit(true)
            return button
        }
    }
}
