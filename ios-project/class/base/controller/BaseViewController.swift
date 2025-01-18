//
//  BaseViewController.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/16.
//

import Foundation
import RxSwift
import UIKit

enum CommonNavigationBarStyle {
    case white
    case lightgray
    
    func color() -> UIColor {
        switch self {
        case .white:        return Color.theme
        case .lightgray:    return Color.lightBackground
        }
    }
}

//private class CustomTitleView: UIView {
//
//    var viewBehindTitle: UIView?
//    var attributeString: ATTR? {
//        didSet {
//            titleL.attributedText = attributeString
//        }
//    }
//    private var titleL: UILabel!
//
//
//    func add(viewBehindTitle view: UIView) {
//        viewBehindTitle?.removeFromSuperview()
//        viewBehindTitle = view
//        addSubview(view)
//        view.snp.makeConstraints { make in
//            make.size.equalTo(view.frame.size)
//            make.left.equalTo(titleL.snp.right).offset(10)
//            make.centerY.equalToSuperview()
//        }
//    }
//
//    override var intrinsicContentSize: CGSize {
//        get {
//            return CGSize(width: screenWidth, height: 44)
//        }
//    }
//
//    convenience init() {
//        self.init(frame: CGRect.zero)
//
//        translatesAutoresizingMaskIntoConstraints = false
//
//        titleL =  UILabel()
//            .font(.roboto(16))
//            .textColor(Color.text)
//            .sizeToFit(true)
//            .txtAlignment(.center)
//        addSubview(titleL)
//
//        titleL.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//        }
//    }
//
//}

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
//    private var customTitleView: CustomTitleView!
    
    private weak var delegate: UIGestureRecognizerDelegate?

    var isViewAppeared = false
//    var viewBehindTitle: UIView? {
//        didSet {
//            guard let viewBehindTitle = viewBehindTitle else {
//                return
//            }
//            customTitleView.add(viewBehindTitle: viewBehindTitle)
//        }
//    }
    
    // 是否需要拦截侧滑返回手势
    func shouldInterceptPanGesture() -> Bool {
        return false
    }
    
    // 拦截
    func panGestureIntercept() {
        
    }
    
    func navigationBarStyle() -> CommonNavigationBarStyle {
        return .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .all
        view.backgroundColor = .white
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.change(navigationBarStyle().color())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewAppeared = true
        if let self = self as? RootViewControllerDelegate {
            self.root_viewWillDidAppear()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let self = self as? RootViewControllerDelegate {
            self.root_viewWillDisappear()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if shouldInterceptPanGesture() && self.delegate?.gestureRecognizerShouldBegin?(gestureRecognizer) ?? false {
            panGestureIntercept()
            return false
        }
        return self.delegate?.gestureRecognizerShouldBegin?(gestureRecognizer) ?? false
    }
}

