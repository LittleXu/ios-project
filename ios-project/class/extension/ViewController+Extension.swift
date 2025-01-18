//
//  ViewController+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    @objc func backAction() {
        pop()
    }
    
    func add(_ subview: UIView) {
        view.addSubview(subview)
    }
    
    func push(_ vc: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func pushNewOrPopExist<T: UIViewController>(target: T, animated: Bool = true) {
        if let vcs = navigationController?.viewControllers {
            let result = vcs.filter { controller in
                return controller.isKind(of: T.self)
            }
            
            if let popTarget = result.first {
                navigationController?.popToViewController(popTarget, animated: animated)
                return
            }
        }
        push(target)
    }
    
    
    // 从栈中删除当前的控制器
    func removeCurrentInStack() {
        if let navc = self.navigationController {
            var array = navc.viewControllers
            array.removeAll { vc in
                return vc == self
            }
            navc.viewControllers = array
        }
    }
    
    // 从栈中删除指定类型的控制 (当前控制器除外)
    func removeClassInStackExceptSelf(cls: UIViewController.Type) {
        if let navc = self.navigationController {
            var array = navc.viewControllers
            array.removeAll { vc in
                return vc.isKind(of: cls) && vc != self
            }
            navc.viewControllers = array
        }
    }
}

extension UIViewController {
    
    func changeNavigationBarBackgroundColor(_ color: UIColor) {
        let appearance = navigationController!.navigationBar.standardAppearance
        appearance.backgroundColor = color
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func changeNavigationBarTextAttributes(_ attributes: [NSAttributedString.Key : Any]) {
        let appearance = navigationController!.navigationBar.standardAppearance
        appearance.titleTextAttributes = attributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
