//
//  BaseTableViewCell.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/16.
//

import Foundation
import UIKit
import RxSwift

extension UITableViewCell {
    class func cellID() -> String {
        return NSStringFromClass(self)
    }
}

extension UITableViewHeaderFooterView {
    class func viewID() -> String {
        return NSStringFromClass(self)
    }
}

extension UICollectionViewCell {
    class func cellID() -> String {
        return NSStringFromClass(self)
    }
}

extension UICollectionReusableView {
    class func viewID() -> String {
        return NSStringFromClass(self)
    }
}

class BaseCollectionReusabelView: UICollectionReusableView {
    class func kind() -> String {
        return UICollectionView.elementKindSectionHeader
    }
}


class BaseHeaderFooterView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
    class func viewHeight() -> CGFloat {
        return 44
    }
}

class BaseTableViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    class func rowHeight() -> CGFloat {
        return 44
    }
    
    class func estimatedRowHeight() -> CGFloat {
        return self.rowHeight()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
}


extension UIView {
    
    struct ShadowContentConfig {
        var backgroundColor: UIColor
        var cornerRadius: CGFloat
        var shadowConfig: UIView.ShadowConfig
        var edge: UIEdgeInsets
    }
}

class BaseShadowTableViewCell: BaseTableViewCell {
    
    var shadowContent: UIView!
    
    func contentConfig() -> UIView.ShadowContentConfig {
        let shadowConfig = UIView.ShadowConfig(color: Color.cellShadow, radius: 15, offset: CGSize(width: 0, height: 2.5), opacity: 1)
        let config = ShadowContentConfig(backgroundColor: Color.background, cornerRadius: 15, shadowConfig: shadowConfig, edge: UIEdgeInsets(top: 7.5, left: 15, bottom: 7.5, right: 15))
        return config
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        super.setupViews()
        
        let contentConfig = contentConfig()
        
        shadowContent = UIView()
        shadowContent.backgroundColor = contentConfig.backgroundColor
        shadowContent.layer.cornerRadius = contentConfig.cornerRadius
        shadowContent.clipsToBounds = true
        contentView.addSubview(shadowContent)
        
        let edge = contentConfig.edge
        
        // layout
        shadowContent.snp.makeConstraints { make in
            make.top.equalTo(edge.top)
            make.left.equalTo(edge.left)
            make.right.equalTo(-edge.right)
            make.bottom.equalTo(-edge.bottom)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let shadowConfig = self.contentConfig().shadowConfig
        self.shadowContent.makeShadow(color: shadowConfig.color, radius: shadowConfig.radius, offset: shadowConfig.offset, opacity: shadowConfig.opacity)
    }

    
    func add(shadowSubview subview: UIView) {
        shadowContent.addSubview(subview)
    }
}
