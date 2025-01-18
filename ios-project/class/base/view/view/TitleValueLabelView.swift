//
//  TitleValueLabelView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/12.
//

import Foundation
import UIKit

// 左右两个标签视图
class HorizonalTitleValueView: UIView {
    var leftLabel: UILabel!
    var rightLabel: UILabel!
    
    convenience init(leftText: String, rightText: String, spacing: CGFloat = 25, isGreaterThanOrEqualTo: Bool = false, leftTextColor: UIColor = Color.subText, rightTextColor: UIColor = Color.text, leftFont: UIFont = .system(14), rightFont: UIFont = .system(14), leftAlign: NSTextAlignment = .left, rightAlign: NSTextAlignment = .left, leftLimitWidth: CGFloat? = nil, rightLimitWidth: CGFloat? = nil) {
        self.init(frame: CGRect.zero)
        
        leftLabel = UILabel()
            .text(leftText)
            .font(leftFont)
            .textColor(leftTextColor)
            .txtAlignment(leftAlign)
            .huggingMore()
        addSubview(leftLabel)
        
        rightLabel = UILabel()
            .text(rightText)
            .font(rightFont)
            .textColor(rightTextColor)
            .txtAlignment(rightAlign)
        addSubview(rightLabel)
        
        // layout
        leftLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(leftFont.lineHeight)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(0)
        }
        
        rightLabel.snp.makeConstraints { make in
            if isGreaterThanOrEqualTo {
                make.left.greaterThanOrEqualTo(leftLabel.snp.right).offset(spacing)
            } else {
                make.left.equalTo(leftLabel.snp.right).offset(spacing)
            }
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(rightFont.lineHeight)
            make.top.greaterThanOrEqualTo(0)
        }
        
        if let leftLimitWidth = leftLimitWidth {
            leftLabel.adjust(true)
            leftLabel.snp.makeConstraints { make in
                make.width.equalTo(leftLimitWidth)
            }
        }
        
        if let rightLimitWidth = rightLimitWidth {
            rightLabel.adjust(true)
            rightLabel.snp.makeConstraints { make in
                make.width.equalTo(rightLimitWidth)
            }
        }
    }
}


// 上下两个标签视图
class TitleValueLabelView: UIView {
    
    var topLabel: UILabel!
    var bottomLabel: UILabel!
    
    convenience init(topText: String, bottomText: String, spacing: CGFloat = 4, sideMargin: CGFloat = 10, topTextColor: UIColor = Color.text, bottomTextColor: UIColor = Color.subText, topFont: UIFont = .roboto_bold(14), bottomFont: UIFont = .system(12), topAlign: NSTextAlignment = .center, bottomAlign: NSTextAlignment = .center) {
        
        self.init(frame: CGRect.zero)
        
        topLabel = UILabel()
            .text(topText)
            .font(topFont)
            .textColor(topTextColor)
            .txtAlignment(topAlign)
        addSubview(topLabel)
        
        bottomLabel = UILabel()
            .text(bottomText)
            .font(bottomFont)
            .textColor(bottomTextColor)
            .txtAlignment(bottomAlign)
        addSubview(bottomLabel)
        
        // layout
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(sideMargin)
            make.right.equalTo(-sideMargin)
            make.height.equalTo(topFont.pointSize + 4)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(spacing)
            make.left.equalTo(sideMargin)
            make.right.equalTo(-sideMargin)
            make.height.equalTo(bottomFont.pointSize + 4)
            make.bottom.equalTo(0)
        }
    }
    
}



// 上下两个标签视图 label后边跟ImageView
class TitleValueLabelImageView: UIView {
    
    var topLabel: UILabel!
    var bottomLabel: UILabel!
    var topImageView: UIImageView?
    var bottomImageView: UIImageView?
    
    convenience init(topText: String, bottomText: String, spacing: CGFloat = 4, sideMargin: CGFloat = 10, topTextColor: UIColor = Color.text, bottomTextColor: UIColor = Color.subText, topFont: UIFont = .roboto_bold(14), bottomFont: UIFont = .system(12), topImage: UIImage? = nil, bottomImage: UIImage? = nil, topImageSize: CGSize = .zero, bottomImageSize: CGSize = .zero, topLabelImageSpacing: CGFloat = 5, bottomLabelImageSpacing: CGFloat = 5, topImageTapAction: B? = nil, bottomImageTapAction: B? = nil, center: Bool = false) {
        
        self.init(frame: CGRect.zero)
        
        topLabel = UILabel()
            .text(topText)
            .font(topFont)
            .textColor(topTextColor)
            .txtAlignment(.left)
            .sizeToFit(true)
        addSubview(topLabel)
        
        bottomLabel = UILabel()
            .text(bottomText)
            .font(bottomFont)
            .textColor(bottomTextColor)
            .txtAlignment(.left)
            .sizeToFit(true)
        addSubview(bottomLabel)
        
        if let topImage = topImage, topImageSize != .zero {
            topImageView = UIImageView(image: topImage)
            addSubview(topImageView!)
            
            if let topImageTapAction = topImageTapAction {
                topImageView?.addViewAction(handle: { _ in
                    topImageTapAction()
                })
            }
            
            // layout
            topImageView?.snp.makeConstraints({ make in
                make.size.equalTo(topImageSize)
                make.left.equalTo(topLabel.snp.right).offset(topLabelImageSpacing)
                make.centerY.equalTo(topLabel)
            })
        }
        
        if let bottomImage = bottomImage, bottomImageSize != .zero {
            bottomImageView = UIImageView(image: bottomImage)
            addSubview(bottomImageView!)
            
            if let bottomImageTapAction = bottomImageTapAction {
                bottomImageView?.addAction(handle: { _ in
                    bottomImageTapAction()
                })
            }
            
            // layout
            bottomImageView?.snp.makeConstraints({ make in
                make.size.equalTo(bottomImageSize)
                make.left.equalTo(bottomLabel.snp.right).offset(bottomLabelImageSpacing)
                make.centerY.equalTo(bottomLabel)
            })
        }
        
        // layout
        topLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            if center {
                make.centerX.equalToSuperview()
            } else {
                make.left.equalTo(sideMargin)
            }
           
            make.height.equalTo(topFont.lineHeight)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(spacing)
            if center {
                make.centerX.equalToSuperview()
            } else {
                make.left.equalTo(sideMargin)
            }
            make.height.equalTo(bottomFont.lineHeight)
            make.bottom.equalTo(0)
        }
    }
    
}
