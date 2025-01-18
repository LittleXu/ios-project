//
//  WebViewController.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/23.
//

import Foundation
@preconcurrency import WebKit
import FDFullscreenPopGesture

class WebViewController: BaseViewController {
    
    private (set) var webview: WKWebView?
    private (set) var progressView: UIProgressView!
//    private var messageHandler: WebViewMessageHandler!
    
    var didCloseBlock: B?
    
    private var url: URL?
    private var html: String?
    private var localHtmlUrl: URL?
    
    var didReceiveMessageBlock: B1<WKScriptMessage>?
    
    
    init(url: URL, title: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
        if title.isNotEmpty {
            self.navigationItem.title = title
        }
    }
    
    init(html: String, title: String) {
        super.init(nibName: nil, bundle: nil)
        self.html = html
        if title.isNotEmpty {
            self.navigationItem.title = title
        }
    }
    
    init(localHtmlUrl: URL, title: String) {
        super.init(nibName: nil, bundle: nil)
        self.localHtmlUrl = localHtmlUrl
        if title.isNotEmpty {
            self.navigationItem.title = title
        }
    }
    
    
    private func setupWebView() {
        let usercontroller = WKUserContentController()
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.userContentController = usercontroller
        
        let webview = WKWebView(frame: .zero, configuration: configuration)
        self.webview = webview
        webview.navigationDelegate = self
        webview.uiDelegate = self
        webview.backgroundColor = Color.background
        webview.isOpaque = false

    }
    
    deinit {
        didCloseBlock?()
        self.webview?.removeObserver(self, forKeyPath: WebViewController.KeyPath.title.rawValue)
        self.webview?.removeObserver(self, forKeyPath: WebViewController.KeyPath.loading.rawValue)
        self.webview?.removeObserver(self, forKeyPath: WebViewController.KeyPath.progress.rawValue)
        self.webview?.removeObserver(self, forKeyPath: WebViewController.KeyPath.canGoBack.rawValue)
        self.webview?.removeObserver(self, forKeyPath: WebViewController.KeyPath.canGoForward.rawValue)
        NotificationCenter.default.removeObserver(self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        DefaultNotificationCenter.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addObserver()
    }
    
    override func backAction() {
        super.backAction()
    }
    
}


// private
extension WebViewController {
    private func setupViews() {
        
        fd_prefersNavigationBarHidden = false
        
        // webview
        setupWebView()
        view.addSubview(webview!)
        
        progressView = UIProgressView()
        progressView.progressTintColor = Color.theme
        add(progressView)
        
        if let url = url {
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
            request.httpShouldHandleCookies = true
            webview?.load(request)
        }
        
        if let html = html, html.isNotEmpty {
            webview?.loadHTMLString(html, baseURL: nil)
        }
        
        if let localHtmlUrl = localHtmlUrl {
            webview?.loadFileURL(localHtmlUrl, allowingReadAccessTo: localHtmlUrl)
        }
        
        
        // layout
        webview?.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        progressView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(2)
        }
    }
}

/// progress
extension WebViewController {
    private func showProgress(with progress: Float) {
        if progress >= 1 {
            progressView.isHidden = true
            progressView.progress = 0
        } else {
            progressView.isHidden = false
            progressView.setProgress(progress, animated: progress > 0)
        }
    }
    
    private func hideProgress() {
        progressView.isHidden = true
        progressView.progress = 0
    }
}

private let actions = [
    "tel",
    "mailto",
    "itms-appss://itunes.apple.com",
    "paytmmp://upi",
    "phonepe://upi",
    "gpay://upi",
    "mobikwik://upi",
    "https://apps.apple.com/",
    "metamask",
    "trust",
    "safe",
    "rainbow",
    "uniswap",
    "zerion",
    "imtokenv2",
    "spot",
    "omni",
    "dfw",
    "tpoutside",
    "robinhood-wallet",
    "frontier",
    "blockchain-wallet",
    "safepalwallet",
    "bitkeep",
    "oneinch",
    "exodus",
    "bnc",
    "ledgerlive",
    "mewwallet",
    "awallet",
    "keyring",
    "lobstr",
    "ontoprovider",
    "mathwallet",
    "unstoppabledomains",
    "obvious",
    "fireblocks-wc",
    "ambire",
    "internetmoney",
    "walletnow",
    "bitcoincom",
    "coin98",
    "arculuswc",
    "cryptobrowser",
    "chainapp",
    "huddln",
    "verso",
    "haha",
    "modularwallet",
    "coinomi",
]

extension WebViewController: WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if (navigationAction.targetFrame == nil) {
            DispatchQueue.main.async {
                self.webview?.load(navigationAction.request)
            }
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(webView.url?.absoluteString)
        var policy = WKNavigationActionPolicy.allow
        if let urlString = navigationAction.request.url?.absoluteString {
            for action in actions {
                if urlString.hasPrefix(action) {
                    Common.open(urlString)
                    policy = .cancel
                    break
                }
            }
        }
        decisionHandler(policy)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideProgress()
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            DispatchQueue.global().async {
                let exceptions = SecTrustCopyExceptions(serverTrust)
                SecTrustSetExceptions(serverTrust, exceptions)
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
            }
            return
        }
        completionHandler(.useCredential, nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgress()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgress()
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        Common.showAlert(message:message, actions: [CommonAlertActionModel.iknow(handler: { _ in
            completionHandler()
        })])
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        Common.showAlert(message:message, actions: [
            CommonAlertActionModel.cancel(handler: { _ in
                completionHandler(false)
            }),
            CommonAlertActionModel.confirm(handler: { _ in
                completionHandler(true)
            })
        ])
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        var alert: UIAlertController? = nil
         alert = Common.showAlert(actions: [CommonAlertActionModel.confirm(handler: { action in
             if let alert = alert, let array = alert.textFields {
                 if let value = array.first?.text {
                     completionHandler(value)
                 }
             }
         })], other: { alert in
             alert.addTextField { field in
                 field.text = defaultText
                 field.placeholder = prompt
             }
         })
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        didReceiveMessageBlock?(message)
    }
}

extension WebViewController {
    private func addObserver() {
        webview?.addObserver(self, forKeyPath: WebViewController.KeyPath.title.rawValue, options: .new, context: nil)
        webview?.addObserver(self, forKeyPath: WebViewController.KeyPath.loading.rawValue, options: .new, context: nil)
        webview?.addObserver(self, forKeyPath: WebViewController.KeyPath.progress.rawValue, options: .new, context: nil)
        webview?.addObserver(self, forKeyPath: WebViewController.KeyPath.canGoBack.rawValue, options: .new, context: nil)
        webview?.addObserver(self, forKeyPath: WebViewController.KeyPath.canGoForward.rawValue, options: .new, context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case KeyPath.title.rawValue:
            let title = change?[.newKey] as? String ?? ""
            navigationItem.title = title
        case KeyPath.loading.rawValue:
            break
        case KeyPath.progress.rawValue:
            let progress = (change?[.newKey] as? Float ?? 0)
            showProgress(with: progress)
        case KeyPath.canGoForward.rawValue:
            break
        case KeyPath.canGoBack.rawValue:
            let enable = change?[.newKey] as? Bool ?? false
            fd_interactivePopDisabled = enable
        default:
            break
        }
    }
}





extension WebViewController {
    private enum KeyPath: String {
        case title          = "title"
        case loading        = "loading"
        case progress       = "estimatedProgress"
        case canGoBack      = "canGoBack"
        case canGoForward   = "canGoForward"
        case ua             = "navigator.userAgent"
    }
    
}
