//
//  ImageTextView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/8.
//

import Foundation
import UIKit

/// 图片和文字排版视图
class ImageTextView: UIView {
    
    var imageView: UIImageView!
    var textL: UILabel!
    
    
    /// 初始化
    /// - Parameters:
    ///   - image: 图片
    ///   - text: 文字
    ///   - position: 图片位置
    ///   - imageSize: 图片尺寸限制
    ///   - textColor: 文字颜色
    ///   - font: 文字字号
    ///   - spacing: 图片与文字距离
    ///   - numOfLines: 文字行数 默认为1
    ///   - limitWith: 换行时文字的限制宽度
    convenience init(image: UIImage?, text: String, position: CommonViewPosition, imageSize: CGSize, textColor: UIColor, font: UIFont, spacing: CGFloat, numOfLines: Int = 1, limitWith: CGFloat = 0) {
        self.init(frame: CGRect.zero)
        
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        textL = UILabel()
            .text(text)
            .textColor(textColor)
            .font(font)
            .sizeToFit(true)
            .numOfLines(numOfLines)
        addSubview(textL)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(imageSize)
        }
        
        if limitWith > 0 {
            textL.snp.makeConstraints { make in
                make.width.lessThanOrEqualTo(limitWith)
            }
        }
        
        // layout
        switch position {
        case .left:
            imageView.snp.makeConstraints { make in
                make.left.centerY.equalToSuperview()
                make.top.greaterThanOrEqualTo(0)
            }
            
            textL.snp.makeConstraints { make in
                make.left.equalTo(imageView.snp.right).offset(spacing)
                make.right.centerY.equalToSuperview()
                make.top.greaterThanOrEqualTo(0)
            }
        case .right:
            textL.snp.makeConstraints { make in
                make.left.centerY.equalToSuperview()
                make.top.greaterThanOrEqualTo(0)
            }
            
            imageView.snp.makeConstraints { make in
                make.right.centerY.equalToSuperview()
                make.top.greaterThanOrEqualTo(0)
                make.left.equalTo(textL.snp.right).offset(spacing)
            }
        case .top:
            imageView.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
                make.left.greaterThanOrEqualTo(0)
            }
            
            textL.snp.makeConstraints { make in
                make.centerX.bottom.equalToSuperview()
                make.left.greaterThanOrEqualTo(0)
                make.top.equalTo(imageView.snp.bottom).offset(spacing)
            }
        case .bottom:
            textL.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
                make.left.greaterThanOrEqualTo(0)
            }
            
            imageView.snp.makeConstraints { make in
                make.bottom.centerX.equalToSuperview()
                make.left.greaterThanOrEqualTo(0)
                make.top.equalTo(textL.snp.bottom).offset(spacing)
            }
        }
        
        let size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
}
