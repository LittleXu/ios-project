//
//  BaseTextSelectionCell.swift
//  ForexSwift
//
//  Created by liuxu on 2022/7/13.
//

import Foundation
import UIKit

class BaseTextSelectionCell: BaseTextCell {
    
    var selectFlag = false {
        didSet {
//            selectImageView.image = selectFlag ? R.image.icon_selected() : nil
        }
    }
    
    private var selectImageView: UIImageView!
    
    override func setupViews() {
        super.setupViews()
        
        selectImageView = UIImageView()
        selectImageView.sizeToFit()
        contentView.addSubview(selectImageView)
        
        // layout
        selectImageView.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
}
