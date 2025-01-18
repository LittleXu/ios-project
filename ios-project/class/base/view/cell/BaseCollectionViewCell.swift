//
//  BaseCollectionViewCell.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/16.
//

import Foundation
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    class func itemSize() -> CGSize {
        return CGSize.zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
