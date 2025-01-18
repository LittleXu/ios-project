//
//  TextFooterView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/9.
//

import Foundation
import UIKit

class TextFooterView: BaseHeaderFooterView {
    
    var text = "" {
        didSet {
            textL.text = text
        }
    }
    var block: B?
    
    private var textL: UILabel!
    
    override func setupViews() {
        super.setupViews()
        
        textL = UILabel()
            .text(text)
            .textColor(Color.subText)
            .font(.system(14))
            .sizeToFit(true)
        textL.addViewAction { _ in
            self.block?()
        }
        contentView.addSubview(textL)
        
        // layout
        textL.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
    }
    
    override class func viewHeight() -> CGFloat {
        return 45
    }
}
