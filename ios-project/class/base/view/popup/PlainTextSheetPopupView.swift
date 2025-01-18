//
//  PlainTextSheetPopupView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/5/12.
//

import Foundation
import UIKit

class PlainTextSheetPopupView: BasePopupView {
    
    private var title = ""
    private var desc = ""
    
    private var titleLabel: UILabel!
    private var descLabel: UILabel!
    private var closeButton: UIButton!
    
    convenience init(_ title: String, desc: String) {
        self.init()
        self.title = title
        self.desc = desc
        setupViews()
    }
    
    private func setupViews() {
        
        let descHeight: CGFloat = desc.sizeFor(maxW: screenWidth - 30, maxH: CGFloat(MAXFLOAT), font: .system(14)).height + 1
        backgroundColor = Color.background
        frame = CGRect(x: 0, y: 0, width: screenWidth, height: 70 + descHeight + 45)
        
        corner(corners: [.topLeft, .topRight], radius: 25)
        
        titleLabel = UILabel()
            .text(title)
            .textColor(Color.text)
            .font(.medium(18))
            .sizeToFit(true)
        addSubview(titleLabel)
        
        closeButton = UIButton()
//            .normalImage(R.image.icon_close_lightgray())
            .action({ [weak self] _ in
                self?.dismiss()
            })
        addSubview(closeButton)
        
        descLabel = UILabel()
            .text(desc)
            .textColor(Color.text)
            .font(.system(14))
            .numOfLines(0)
            .sizeToFit(true)
        addSubview(descLabel)
        
        // layout
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(20)
        }
        
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(70)
        }
    }
    
}

