//
//  BaseTextCell.swift
//  ForexSwift
//
//  Created by liuxu on 2022/5/17.
//

import Foundation
import UIKit


class BaseTextCell: BaseTableViewCell {
    
    var titleLabel: UILabel!
    var contentLabel: UILabel!
    
    override class func rowHeight() -> CGFloat {
        return 38
    }
    
    override func setupViews() {
        super.setupViews()
        
        titleLabel = UILabel()
            .textColor(Color.subText)
            .font(.system(14))
            .sizeToFit(true)
            .huggingMore()
        
        contentLabel = UILabel()
            .textColor(Color.text)
            .font(.roboto_bold(14))
            .sizeToFit(true)
            .huggingLess()
        
        contentView.appendSubviews(with: [titleLabel, contentLabel])
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(12).priority(.medium)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(15)
            make.top.greaterThanOrEqualTo(12).priority(.medium)
        }
    }
    
}


class BaseTextIndicatorCell: BaseTextCell {
    
    var arrowImageView: UIImageView!
    
    override func setupViews() {
        super.setupViews()
        
        arrowImageView = UIImageView()
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.sizeToFit()
        contentView.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        contentLabel.snp.remakeConstraints { make in
            make.right.equalTo(arrowImageView.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(15)
        }
    }
    
}




class BaseTextContainerCell: BaseTextCell {
    var container: UIView!
    
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
        
        contentLabel.snp.updateConstraints { make in
            make.right.equalTo(-30)
        }
    }
}


class BaseTextContainerIndicatorCell: BaseTextContainerCell {
    private var arrowImageView: UIImageView!

    override func setupViews() {
        super.setupViews()
        
        arrowImageView = UIImageView()
        arrowImageView.sizeToFit()
        contentView.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalTo(-30)
            make.centerY.equalToSuperview()
        }
        
        contentLabel.snp.remakeConstraints { make in
            make.right.equalTo(arrowImageView.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(15)
        }
    }
}
