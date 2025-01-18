//
//  BaseTabBarController.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/16.
//

import Foundation
import UIKit

protocol RootViewControllerDelegate {
    func root_viewWillDidAppear()
    func root_viewWillDisappear()
}

class BaseTabBarController: UITabBarController {
        
    private var supportInviteTab = true {
        didSet {
            self.viewControllers?.removeAll()
            self.config()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        
        view.backgroundColor = Color.background
        tabBar.tintColor = Color.text
        tabBar.isTranslucent = false
    }
    
    deinit {
        DefaultNotificationCenter.removeObserver(self)
    }
    
    
    private func config() {
        var datas: [BaseNavigationViewController] = []
        let home = createTabbarItem(vc: CommentsViewController(), title: "热评", image: UIImage(named: "icon_home"), selectedImage: UIImage(named: "icon_home")?.withTintColor(Color.theme))
        let category = createTabbarItem(vc: MoviesViewController(), title: "电影", image: UIImage(named: "icon_category"), selectedImage: UIImage(named: "icon_category")?.withTintColor(Color.theme))
        let setting = createTabbarItem(vc: MeViewController(), title: "我的", image: UIImage(named: "icon_setting"), selectedImage: UIImage(named: "icon_setting")?.withTintColor(Color.theme))
        datas = [home, category, setting]
        
    
        
        _ = datas.map { navc in
            addChild(navc)
        }
    }
    
    private func createTabbarItem(vc: UIViewController & RootViewControllerDelegate, title: String, image: UIImage?, selectedImage: UIImage?) -> BaseNavigationViewController {
        let item = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        vc.tabBarItem = item
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.roboto(12), NSAttributedString.Key.foregroundColor: Color.theme], for: .selected)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.roboto(12), NSAttributedString.Key.foregroundColor: Color.subText], for: .normal)
        let navc = BaseNavigationViewController(rootViewController: vc)
        return navc
    }
    
    
    // MARK: -
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}



