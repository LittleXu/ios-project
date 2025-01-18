//
//  CustomNavigationBar.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/29.
//

import Foundation
import UIKit

class CustomNavigationBar: BaseView {
    
    var backB: UIButton!
    private var titleL: UILabel!
    private var titleImageB: UIButton?
    private var rightB: UIButton?
    
    private var title = ""
    
    
    private var normalBackImage: UIImage?
    private var scrollBackImage: UIImage?
    private var normalTitleColor = UIColor.white
    private var scrollTitleColor = Color.text
    private var normalBackgroundColor = UIColor.clear
    private var scrollBackgroundColor = Color.background
    private weak var scrollView: UIScrollView? = nil
    
    private var titleFont = UIFont.semibold(18)
    
    convenience init(_ title: String,
                     normalBackImage: UIImage? = nil,
                     scrollBackImage: UIImage? = nil,
                     normalTitleColor: UIColor = UIColor.white,
                     scrollTitleColor: UIColor = Color.text,
                     normalBackgroundColor: UIColor = .clear,
                     scrollBackgroundColor: UIColor = Color.background,
                     titleImageButton: UIButton? = nil,
                     rightButton: UIButton? = nil,
                     scrollView: UIScrollView? = nil) {
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: 44 + 64)
        self.init(frame: frame)
        
        self.title = title
        self.normalBackImage = normalBackImage
        self.scrollBackImage = scrollBackImage
        self.normalTitleColor = normalTitleColor
        self.scrollTitleColor = scrollTitleColor
        self.normalBackgroundColor = normalBackgroundColor
        self.scrollBackgroundColor = scrollBackgroundColor
        self.titleImageB = titleImageButton
        self.rightB = rightButton
        self.scrollView = scrollView
        setupViews()
    }
    
    private func setupViews() {
        
        backB = UIButton()
            .normalImage(normalBackImage)
            .action({ _ in
                Common.currentViewController()?.pop()
            })
        addSubview(backB)
        
        titleL = UILabel()
            .text(title)
            .textColor(normalTitleColor)
            .font(titleFont)
            .sizeToFit(true)
        addSubview(titleL)
        
        if let scrollView = scrollView {
            scrollView.rx.observe(CGPoint.self, "contentOffset").subscribe(onNext: { [weak self] point in
                guard let self = self, let point = point else { return }
                self.handle(point)
            }).disposed(by: disposeBag)
        }
        
        // layout
        backB.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.bottom.equalTo(0)
            make.height.equalTo(44)
            make.width.equalTo(34)
        }
        
        titleL.snp.makeConstraints { make in
            make.left.equalTo(backB.snp.right).offset(6)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
        
        
        if let titleImageB = titleImageB {
            addSubview(titleImageB)
            titleImageB.snp.makeConstraints { make in
                make.left.equalTo(titleL.snp.right).offset(8)
                make.centerY.equalTo(titleL)
                make.size.equalTo(titleImageB.frame.size)
            }
        }
        
        if let rightB = rightB {
            addSubview(rightB)
            
            rightB.snp.makeConstraints { make in
                make.right.equalTo(-15)
                make.centerY.equalTo(backB)
                make.size.equalTo(rightB.frame.size)
            }
        }
    }
    
    private func handle(_ point: CGPoint) {
        
        let y = point.y
        var progress: CGFloat = 0
        if y > (44 + 64) {
            progress = 1
        } else if y > 0 {
            progress = y / 64
        } else {
            progress = 0
        }
        
        self.backgroundColor = Color.background.withAlphaComponent(progress)
        if progress > 0.2 {
            self.backB.normalImage(scrollBackImage)
            self.titleL.textColor = scrollTitleColor
            self.titleImageB?.isSelected = true
            self.rightB?.isSelected = true
        } else {
            self.backB.normalImage(normalBackImage)
            self.titleL.textColor = normalTitleColor
            self.titleImageB?.isSelected = false
            self.rightB?.isSelected = false
        }
    }
}
