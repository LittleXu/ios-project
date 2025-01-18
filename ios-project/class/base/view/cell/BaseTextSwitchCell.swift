//
//  BaseTextSwitchCell.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/11.
//

import Foundation
import UIKit
import ObjectMapper

class BaseTextSwitchCell: BaseTableViewCell {
    
    var model: BaseCellSwitchModel? {
        didSet {
            guard let model = model else {
                return
            }

            titleLabel.text = model.title
            switchView.isOn = model.on
            block = model.changedBlock
        }
    }
    
    private var block: B1<Bool>? {
        didSet {
            switchView.valueChangedBlock = block
        }
    }
    
    var titleLabel: UILabel!
    var switchView: SwitchView!
    
    override class func rowHeight() -> CGFloat {
        return 44
    }
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel = UILabel()
            .textColor(Color.text)
            .font(.system(14))
            .sizeToFit(true)
            .huggingMore()
        contentView.addSubview(titleLabel)
        
        switchView = SwitchView()
        switchView.valueChangedBlock = block
        contentView.addSubview(switchView)
        
        // layout
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(switchView.snp.left).offset(-15)
        }
        
        switchView.snp.makeConstraints { make in
            make.size.equalTo(switchView.frame.size)
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
        }
    }
}


class BaseTextSwitchContainerCell: BaseTextSwitchCell {
    
    private var container: UIView!
    
    override func setupViews() {
        super.setupViews()
        
        contentView.backgroundColor = Color.lightBackground
        
        container = UIView()
        container.backgroundColor = Color.background
        contentView.insertSubview(container, at: 0)
        
        container.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.updateConstraints { make in
            make.left.equalTo(30)
        }
        
        switchView.snp.updateConstraints { make in
            make.right.equalTo(-30)
        }
    }
    
}
