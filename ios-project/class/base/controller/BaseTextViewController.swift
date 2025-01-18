//
//  BaseTextViewController.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/7.
//

import Foundation
import UIKit

extension Common {
    
    static func textPara() -> NSMutableParagraphStyle {
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 3
        para.alignment = .left
        para.lineBreakMode = .byCharWrapping
        return para
    }
    
}

class BaseTextViewController: BaseTableViewController {
    
    private var attributeString: ATTRM?
    
    private var textL: UILabel!
    
    init(_ title: String, attr: ATTRM) {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = title
        self.attributeString = attr
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupTableHeaderViews() {
        super.setupTableHeaderViews()
        
        textL = UILabel()
            .numOfLines(0)
            .sizeToFit(true)
        textL.attributedText = attributeString
        tableHeaderView.addSubview(textL)
        
        textL.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
        }
    }
}
