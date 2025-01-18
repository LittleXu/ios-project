//
//  AppDelegate.swift
//  ios-project
//
//  Created by liuxu on 2025/1/13.
//

import UIKit
import Alamofire
import AppTrackingTransparency
import AdSupport



@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    private var rechabilityManager: NetworkReachabilityManager?
    var idfv = ""
    var idfa = ""
    var notShowEula = UserDefaults.standard.bool(forKey: "ios-project-eula")
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        forwardActions()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = Color.background
        window?.rootViewController = BaseTabBarController()
        window?.makeKeyAndVisible()
        
        // 用户使用条款
        if !notShowEula {
            popupUserClients()
            UserDefaults.standard.set(true, forKey: "ios-project-eula")
            UserDefaults.standard.synchronize()
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        requestTracking()
    }
    
    func forwardActions() {
        Common.initLog()
        
        rechabilityManager = NetworkReachabilityManager.default
        rechabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            if status == .reachable(.ethernetOrWiFi) || status == .reachable(.cellular) {
                Common.LOG(.trace, "现在有网啦!")
                Common.fetch(nil)
                self?.rechabilityManager?.stopListening()
            }
        })
    }
    
    func popupUserClients() {
        let button = UIButton()
            .normalTitle("点击查看《用户使用条款（EULA）》")
            .normalTitleColor(Color.theme)
            .font(.system(15))
            .sizeToFit(true)
            .action { _ in
                print("EULA")
                Common.currentViewController()?.dismiss(animated: false)
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: "eula", ofType: "html")!)
                Common.openWeb(url)
            }
        
        let alert = AlertActionPopupExtraView("用户使用条款（EULA）", contentAttr: "欢迎使用微评电影，请仔细阅读以下使用条款，这些条款构成你与我们之间关于使用本平台的法律协议。通过访问或使用此功能，您即表示同意接受这些条款的约束。如果您不同意这些条款，请不要使用此功能。".toATTR(with: AlertActionPopupExtraView.attributes()), extraView: button,  actions: [
            AlertActionModel(title: "不同意", type: .cancel, block: nil),
            AlertActionModel(title: "同意", type: .sure, block: nil)
        ])
        alert.show(in: Common.currentViewController())
    }
    
    
   
    
    private func requestTracking() {
        idfv = UIDevice.current.identifierForVendor?.uuidString ?? ""
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                self?.idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                self.idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        }
    }
}

extension Common {
    
    
    static func fetch(_ completion: B?) {
        // API URL
        let url = "https://api.github.com/users/LittleXu"
        // 发起 GET 请求
        AF.request(url, method: .get, headers: [
            "Accept": "application/vnd.github.v3+json"
        ]).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    // 解析 JSON 数据
                    print("GitHub User Info: \(json)")
                    // 提取字段
                    if let login = json["login"] as? String,
                       let id = json["id"] as? Int,
                       let avatarUrl = json["avatar_url"] as? String {
                        print("Login: \(login)")
                        print("ID: \(id)")
                        print("Avatar URL: \(avatarUrl)")
                    }
                }
            case .failure(let error):
                // 打印错误信息
                print("Request failed: \(error.localizedDescription)")
            }
            
            completion?()
        }
    }
}

