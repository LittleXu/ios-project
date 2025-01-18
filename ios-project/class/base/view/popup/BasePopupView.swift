//
//  BasePopupView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/31.
//

import Foundation
import UIKit
import ObjectMapper
import TYAlertController
class BasePopupViewGroup: NSObject {
    static let shared = BasePopupViewGroup()
    
    private var views: [BasePopupView] = []
    
    class func add(_ view: BasePopupView) {
        if shared.views.isEmpty {
            view.show()
        }
        Common.LOG(.info, shared.views)
        shared.views.append(view)
    }
    
    class func remove(_ view: BasePopupView) {

        shared.views.removeAll { v in
            return v == view
        }
        
        if let view = shared.views.first {
            view.show()
        }
    }
}

class BasePopupView: UIView {
    
    var dismissBlock: B? {
        didSet {
            alertController?.dismissComplete = dismissBlock
        }
    }
    var backgoundTapDismissEnable = true
    
    private weak var alertController: TYAlertController?
    
    private var type: TYAlertControllerStyle = .alert
    private var controller: UIViewController?
    private var config: B1<TYAlertController>?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        let frame = UIScreen.main.bounds
        
        //
        let width = frame.width * widthAdaptePercent()
        
        var originFrame = self.frame
        originFrame.width = width
        self.frame = originFrame
    }
    
    func widthAdaptePercent() -> CGFloat {
        if screenWidth < 400 { return 0.91 }
        return 0.8
    }
    
    func showPopup(_ type: TYAlertControllerStyle = .alert, vc: UIViewController? = nil, config: B1<TYAlertController>? = nil) {
        self.type = type
        self.controller = vc
        self.config = config
        
        BasePopupViewGroup.add(self)
    }
    
    
    fileprivate func show() {
        
        guard let vc = controller ?? Common.currentViewController() else { return }
        layoutIfNeeded()
        guard let alert = TYAlertController(alert: self, preferredStyle: type, transitionAnimation: type == .alert ? .scaleFade : .fade) else { return }
        alert.dismissComplete = self.dismissBlock
        alert.viewDidHideHandler = { [weak self] _ in
            guard let self = self else { return }
            BasePopupViewGroup.remove(self)
        }
        let width = screenWidth
        let padding = (width - bounds.width) * 0.5
        alert.alertStyleEdging = padding
        alert.backgoundTapDismissEnable = backgoundTapDismissEnable
        config?(alert)
        alertController = alert
        vc.present(alert, animated: true)
    }

    
    func dismiss(block: B? = nil) {
        dismissBlock = block
        if let alertController = alertController {
            alertController.dismiss(animated: true, completion: { [weak self] in
                self?.alertController = nil
                self?.dismissBlock?()
            })
        } else {
            hideInController()
        }
    }
}


struct TextActionSheetModel {
    var title = ""
    var block: B?
}
