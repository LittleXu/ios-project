//
//  SwitchView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/1.
//

import Foundation
import UIKit

class DisableHighlightedButton: UIButton {
    override var isHighlighted: Bool {
        set {
            // 不作处理
        }
        get {
            return false
        }
    }
}

class SwitchView: BaseView {
    
    var isOn: Bool {
        get {
            return button.isSelected
        }
        set {
            button.isSelected = newValue
        }
    }
    
    var valueChangedBlock: B1<Bool>?
    
    private var button: DisableHighlightedButton!
    
    convenience init() {
        let frame = CGRect(x: 0, y: 0, width: 23, height: 14)
        self.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        button = DisableHighlightedButton(frame: self.bounds)
//            .normalImage(R.image.icon_switch_off())
//            .selectedImage(R.image.icon_switch_on())
            .action({ [weak self] btn in
                // 震动一下
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                btn.isSelected = !btn.isSelected
                self?.valueChangedBlock?(btn.isSelected)
            })
        addSubview(button)
    }
    
    @discardableResult
    func orangeStyle() -> Self {
//        button.selectedImage(R.image.icon_switch_on_orange())
        return self
    }
}
