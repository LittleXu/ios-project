//
//  BaseNavigationViewController.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/16.
//

import Foundation
import UIKit

class BaseNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.navigationBar.barTintColor = Color.background
        self.navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                
        let appearance = navigationBar.standardAppearance
        appearance.shadowImage = UIColor.clear.asImage()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.roboto(16)]
        appearance.backgroundColor = Color.background
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
}

extension BaseNavigationViewController: UINavigationControllerDelegate {
        
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count > 0 {
            if viewController.navigationItem.hidesBackButton {
                viewController.navigationItem.hidesBackButton = true
            } else {
                let image = UIImage(named: "icon_back")?.withTintColor(.white)
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: image, style: .plain, target: viewController, action: #selector(backAction))
            }

            viewController.hidesBottomBarWhenPushed = true

        }
        super.pushViewController(viewController, animated: animated)
    }
}


extension UINavigationController {
    func change(_ color: UIColor) {
        let appearance = navigationBar.standardAppearance
        appearance.backgroundColor = color
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
}

