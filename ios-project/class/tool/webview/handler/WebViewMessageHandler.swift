////
////  WebViewMessageHandler.swift
////  ForexSwift
////
////  Created by liuxu on 2022/3/23.
////
//
//import Foundation
//import WebKit
//import Kingfisher
//import ObjectMapper
//
//
//enum CommonBridge: String, CaseIterable {
//    case close                  = "close"
//    case token                  = "getToken"
//    case getUserInfo            = "getUserInfo"
//    case openPage               = "openPage"
//    case showLoading            = "showLoading"
//    case showLoadingDialog      = "showLoadingDialog"
//    case showDialog             = "showDialog"
//    case showImages             = "showImages"
//    case header                 = "generalHeader"
//    case deviceInfo             = "getGeneralUserAndDeviceInfo"
//    case toast                  = "toast"
//    case theme                  = "getTheme"
//    case analyse                = "analyseEvent"
//    case recharge               = "rechargeEvent"
//    case showShareDialog        = "showShareDialog"
//    case userInfo               = "userInfo"
//    case photo                  = "getPhoto"
//    case showShareMenu          = "showShareMenu"
//    case appName                = "getAppName"
//    case showTrade              = "isShowTrade"
//    case enablBackAndForward    = "enablBackAndForward"
//    case encryptParams          = "encryptParams"
//    case encryptParamsWithJson  = "encryptParamsWithJson"
//    case openTradeAccount       = "openTradeAccount"
//    case saveImage              = "saveImage"
//    case pending                = "pending"
//    case buy                    = "buy"
//    case sell                   = "sell"
//    case getThemeColor          = "getThemeColor"
//}
//
//class WebViewMessageHandler: NSObject {
//    
//    private weak var webview: WKWebView?
//    private weak var messageHandler: WKScriptMessageHandler?
//    private weak var webviewController: UIViewController?
//    
//    private (set) var disableBackAndForward: Bool = true
//    
//    var onCloseWebViewBlock: B?
//    
//    init(webview: WKWebView, messageHandler: WKScriptMessageHandler, webviewController: UIViewController) {
//        self.webview = webview
//        self.messageHandler = messageHandler
//        self.webviewController = webviewController
//    }
//    
//    func addAll() {
//        _ = CommonBridge.allCases.map { [self] bridge in
//            guard let messageHandler = messageHandler else {
//                return
//            }
//
//            self.webview?.configuration.userContentController.add(messageHandler, name: bridge.rawValue)
//        }
//    }
//    
//    func removeAll() {
//        _ = CommonBridge.allCases.map({ [self] bridge in
//            self.webview?.configuration.userContentController.removeScriptMessageHandler(forName: bridge.rawValue)
//        })
//    }
//    
//    func handle(message: WKScriptMessage) -> Bool {
//        if let bridge = CommonBridge(rawValue: message.name) {
//            let callback = callbackMethod(message) ?? ""
//            switch bridge {
//            case .close:
//                onCloseWebViewBlock?()
//            case .token:
//                let string = UserManager.isLogin ? UserManager.manager.token : ""
//                doCallback(callback, paramString: string)
//            case .getUserInfo:
//                var string = ""
//                if let user = UserManager.manager.user {
//                    string = user.toJSONString() ?? ""
//                }
//                doCallback(callback, paramString: string)
//            case .openPage:
//                if let body = message.body as? [String : Any], let url = body["url"] as? String, url.isNotEmpty {
//                    if url == RouterType.login.rawValue { // 登录
//                        self.webviewController?.toLogin({ [weak self] in
//                            let token = UserManager.manager.token
//                            let params = ["token": token]
//                            self?.doCallback(callback, params: params)
//                        })
//                    } else {
//                        Router.router(url)
//                    }
//                }
//                break
//            case .showLoading, .showLoadingDialog:
//                var show = false
//                if let body = message.body as? [String : Any] {
//                    show = body["isShow"] as? Bool ?? false
//                }
//                if show {
//                    self.webview?.superview?.showLoading()
//                } else {
//                    self.webview?.superview?.hideLoading()
//                }
//            case .showDialog:
//                if let body = message.body as? [String : Any]  {
//                    if let model = Mapper<BridgeDialogModel>().map(JSON: body) {
//                        let alert = UIAlertController(title: model.title, message: model.desc, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: model.negativeStr.isNotEmpty ?  model.negativeStr : R.string.localizable.btn_Cancel(), style: .cancel, handler: { [weak self] _ in
//                            self?.doCallback(model.negativeCallback, params: nil)
//                        }))
//                        alert.addAction(UIAlertAction(title: model.positiveStr.isNotEmpty ? model.positiveStr : R.string.localizable.btn_Confirm(), style: .default, handler: { [weak self] _ in
//                            self?.doCallback(model.positiveCallback, params: nil)
//                        }))
//                        self.webviewController?.present(alert, animated: true)
//                    }
//                }
//            case .showImages:
//                if let body = message.body as? [String : Any] {
//                    let index = (body["index"] as? String ?? "0").intValue
//                    if let imageList = body["imgList"] as? [[String : Any]] {
//                        var images = imageList.map { dict -> String in
//                            let url = dict["url"] as? String ?? ""
//                            return url
//                        }
//                        
//                        images = images.filterDuplicates { string in
//                            return string.isNotEmpty
//                        }
//                        
//                        if images.isNotEmpty {
//                            Common.showPhotoBrowser(images, index: index)
//                        }
//                    }
//                }
//            case .header:
//                doCallback(callback, params: DeviceInfo.sharedInfo.info)
//            case .deviceInfo:
//                let params = [
//                    "token": UserManager.isLogin ? UserManager.manager.token : "",
//                    "header": DeviceInfo.sharedInfo.info,
//                ] as [String : Any]
//                doCallback(callback, params: params)
//            case .toast:
//                if let body = message.body as? [String : Any], let text = body["message"] as? String {
//                    self.webview?.superview?.showToast(text)
//                }
//            case .theme:
//                let theme = self.webview?.traitCollection.userInterfaceStyle == .dark ? "DARK" : "LIGHT"
//                doCallback(callback, paramString: theme)
////            case .analyse:
////                if let body = message.body as? [String : Any], let eventId = body["eventId"] as? String, eventId.isNotEmpty, let map = body["map"] as? [String : Any] {
////                    Common.logEvents(eventsString: eventId, extram: map)
////                }
//            case .recharge: // 这个暂时没啥用
//                break
//            case .showShareDialog:
//                if let body = message.body as? [String : Any] {
//                    let title = body["title"] as? String ?? ""
//                    let link = body["link"] as? String ?? ""
//                    let imageurl = body["imgUrl"] as? String ?? ""
//                    
//                    share(title, link: link, imageUrl: imageurl)
//                }
//            
//            case .userInfo:
//                var string = ""
//                if let user = UserManager.manager.user {
//                    string = user.toJSONString() ?? ""
//                }
//                doCallback(callback, paramString: string)
//            case .photo:    // 暂时没有用
//                break
////            case .showShareMenu:    //
////                if let body = message.body as? [String : Any] {
////                    let isShow = body["isShow"] as? Bool ?? false
////                    let title = body["title"] as? String ?? ""
////                    let link = body["link"] as? String ?? ""
////                    let imageUrl = body["imgUrl"] as? String ?? ""
////
////                    if let webviewController = webviewController {
////                        if isShow {
////                            let button = UIButton().normalImage(R.image.icon_share())
////                                .action { [weak self] _ in
////                                    self?.share(title, link: link, imageUrl: imageUrl)
////                                }
////                            webviewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
////                        } else {
////                            webviewController.navigationItem.rightBarButtonItem = nil
////                        }
////                    }
////                }
////                break
//            case .appName:
//                doCallback(callback, paramString: Bundle.main.appName ?? "")
//            case .showTrade:    // 暂时没用
//                break
//            case .enablBackAndForward:
//                if let body = message.body as? [String : Any] {
//                    let enable = body["enable"] as? Bool ?? false
//                    disableBackAndForward = enable
//                }
//            case .encryptParams:
//                if let body = message.body as? [String : Any] {
//                    if let params = body["params"] as? [String : Any] {
//                        let encryptParams = params.toEncryptSort().encypt()
//                        doCallback(callback, params: encryptParams)
//                    }
//                }
//            case .encryptParamsWithJson:
//                if let body = message.body as? [String : Any] {
//                    if let params = body["params"] as? [String : Any] {
//                        let encryptParams = params.toJSON().encypt()
//                        doCallback(callback, params: encryptParams)
//                    }
//                }
////            case .openTradeAccount:
////                if let body = message.body as? [String : Any] {
////                    AccountManager.manager.doOpenLiveAccount()
////                }
//            case .saveImage:
//                if let body = message.body as? [String : Any] {
//                    if let base64 = body["image"] as? String {
//                        if let image = base64.base64ToImage() {
//                            Common.saveImage(image)
//                        }
//                    }
//                }
////            case .pending, .buy, .sell:
////                if let body = message.body as? [String : Any] {
////                    if let symbolCode = body["symbolCode"] as? String, let type = CommonTranscationType.type(with: bridge) {
////                        Common.showQuickTranscationPopup(symbolCode, type: type)
////                    }
////                }
//            case .getThemeColor:
//                // MARK: - TODO
//                self.doCallback(callback, params: ["increaseColor":  Color.increase().hexString() ?? "", "decreaseColor" : Color.decrease().hexString() ?? ""])
//                break
//                
//            default:
//                break
//            }
//            
//            return true
//        }
//       
//        
//        return false
//        
//    }
//    
//    
//    private func share(_ title: String, link: String, imageUrl: String) {
//        var items: [Any] = []
//        if title.isNotEmpty {
//            items.append(title)
//        }
//        
//        if link.isNotEmpty, let linkUrl = URL(string: link) {
//            items.append(linkUrl)
//        }
//        
//        if imageUrl.isNotEmpty, let url = URL(string: imageUrl) {
//            webviewController?.view.showLoading()
//            ImageDownloader.default.downloadImage(with: url) { [weak self] result in
//                guard let self = self else { return }
//                self.webviewController?.view.hideLoading()
//                switch result {
//                case .success(let data):
//                    items.append(data.image)
//                case .failure(_):
//                    break
//                }
//                Common.systemshare(items, on: self.webviewController)
//            }
//        } else {
//            Common.systemshare(items, on: self.webviewController)
//        }
//    }
//}
//
//// callback
//extension WebViewMessageHandler {
//   
//    private func callbackMethod(_ message: WKScriptMessage) -> String? {
//        guard let body = message.body as? [String : Any] else { return nil }
//        return body["callback"] as? String
//    }
//    
//    private func doCallback(_ callback: String, params: [String : Any]?) {
//        if callback.isEmpty { return }
//        var paramString = ""
//        if let params = params {
//            if let jsondata = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed) {
//                paramString = String(data: jsondata, encoding: .utf8) ?? ""
//            }
//        }
//        doCallback(callback, paramString: paramString)
//    }
//    
//    private func doCallback(_ callback: String, paramString: String) {
//        if callback.isEmpty { return }
//        var js = ""
//        if paramString.isNotEmpty {
//            js = "\(callback)(`\(paramString)`)"
//        } else {
//            js = "\(callback)()"
//        }
//        self.webview?.evaluateJavaScript(js, completionHandler: { result, error in
//            if error != nil {
//                print("bridge回调失败")
//                print(error?.localizedDescription ?? "")
//            }
//        })
//    }
//
//}
//
//
//struct BridgeDialogModel: Mappable {
//    init?(map: ObjectMapper.Map) {
//        title <- map["title"]
//        desc <- map["desc"]
//        positiveStr <- map["positiveStr"]
//        negativeStr <- map["negativeStr"]
//        positiveCallback <- map["positiveCallback"]
//        negativeCallback <- map["negativeCallback"]
//    }
//    
//    mutating func mapping(map: ObjectMapper.Map) {
//        
//    }
//    
//    var title = ""
//    var desc = ""
//    var positiveStr = ""
//    var negativeStr = ""
//    var positiveCallback = ""
//    var negativeCallback = ""
//}
