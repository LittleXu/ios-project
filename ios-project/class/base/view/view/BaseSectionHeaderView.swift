//
//  BaseSectionHeaderView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/7/13.
//

import Foundation
import UIKit

class BaseSectionHeaderView: UIView {
    
    var titleLabel: UILabel!
    
    convenience init(title: String, height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: height))
    
        backgroundColor = Color.lightBackground
        titleLabel = UILabel()
            .text(title)
            .font(.system(12))
            .textColor(Color.text)
            .sizeToFit(true)
        addSubview(titleLabel)
        
        // layout
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
    }
    
}
