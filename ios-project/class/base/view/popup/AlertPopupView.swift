//
//  AlertPopupView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/1.
//  类似签到页面的弹窗 样式如下
//  https://lanhuapp.com/web/#/item/project/detailDetach?pid=59ff55bb-ef81-48ec-bc58-50125c95bbd9&project_id=59ff55bb-ef81-48ec-bc58-50125c95bbd9&image_id=5bdd0c61-5c87-4724-9d98-3f794dcdc4b0&fromEditor=true

import Foundation
import UIKit

struct AlertPopupConfig {
    var image: UIImage
    var content: ATTR
    var tips: ATTR
    
    
//    static func signInSuccess(sign: SignResultModel, config: [SignConfigModel], progress: SignProgressModel) -> Self {
//        let attrm = Common.attrm(R.string.localizable.sign_Tomorrow_Reward(), textColor: Color.subText)
//        // 判断明天是宝箱还是积分
//        let currentDay = progress.currentDay
//        var tomorrowConfig = config.first
//        if config.count > currentDay { // 如果能取到明天就取明天, 取不到就默认第一条
//            tomorrowConfig = config[currentDay]
//        }
//        let text = (tomorrowConfig?.u_type == .box) ? R.string.localizable.sign_Secret_Box() : "+\(tomorrowConfig?.reward ?? "0") \(R.string.localizable.integral()) "
//        attrm.append(Common.attr(text, textColor: Color.orangeText))
//        var content = "\(R.string.localizable.sign_Success())\n\(R.string.localizable.sign_Congratulation())"
//        if sign.rewardIntegral.doubleValue > 0 {
//            content += "\n"
//            content += "+\(sign.rewardIntegral) \(R.string.localizable.integral())"
//        }
//        if sign.rewardCash.doubleValue > 0 {
//            content += "\n"
//            content += "+$\(sign.rewardCash)"
//        }
//
//        return AlertPopupConfig(image: R.image.icon_popup_coin()!, content: AlertPopupView.contentAttr(content), tips: attrm.copy() as! ATTR)
//    }
//
//    // 签到中断
//    static func signInterrupt(progress: SignProgressModel) -> Self {
//        return AlertPopupConfig(image: R.image.icon_popup_cry()!, content: AlertPopupView.contentAttr(R.string.localizable.sign_Regret()), tips: AlertPopupView.tipsAttr(R.string.localizable.sign_Interrupt()))
//    }
//
//    static func boxOpen(sign: SignResultModel, config: [SignConfigModel], progress: SignProgressModel) -> Self {
//        let attrm = Common.attrm(R.string.localizable.sign_Tomorrow_Reward(), textColor: Color.subText)
//        let currentDay = progress.currentDay
//        var tomorrowConfig = config.first
//        if config.count > currentDay { // 如果能取到明天就取明天, 取不到就默认第一条
//            tomorrowConfig = config[currentDay]
//        }
//        let text = (tomorrowConfig?.u_type == .box) ? R.string.localizable.sign_Secret_Box() : "+\(tomorrowConfig?.reward ?? "0") \(R.string.localizable.integral())"
//        attrm.append(Common.attr(text, textColor: Color.orangeText))
//
//
//        var content = "\(R.string.localizable.sign_Open_Box_Success())\n\(R.string.localizable.sign_Congratulation())"
//        if sign.rewardIntegral.doubleValue > 0 {
//            content += "+\(sign.rewardIntegral)\(R.string.localizable.integral())"
//        }
//        if sign.rewardCash.doubleValue > 0 {
//            content += "+$\(sign.rewardCash)"
//        }
//        return AlertPopupConfig(image: R.image.icon_popup_box()!, content: AlertPopupView.contentAttr(content), tips: attrm.copy() as! ATTR)
//    }
}

class AlertPopupView: BasePopupView {
    
    private var image: UIImage!
    private var content: ATTR!
    private var tips: ATTR!
    
    private var container: UIView!
    private var imageView: UIImageView!
    private var contentL: UILabel!
    private var tipL: UILabel!
    
    
    convenience init (_ config: AlertPopupConfig) {
        self.init(config.image, content: config.content, tips: config.tips)
    }
    
    convenience init(_ image: UIImage, content: ATTR, tips: ATTR) {
        self.init()
        
        self.image = image
        self.content = content
        self.tips = tips
        
        setupViews()
    }
    
    
    private func setupViews() {
        
        container = UIView()
        container.backgroundColor = Color.background
        container.layer.cornerRadius = 30
        addSubview(container)
        
        imageView = UIImageView(image: image)
        addSubview(imageView)
        
        contentL = UILabel()
            .numOfLines(0)
            .txtAlignment(.center)
            .sizeToFit(true)
        contentL.attributedText = content
        container.addSubview(contentL)
        
        tipL = UILabel()
            .numOfLines(0)
            .txtAlignment(.center)
            .sizeToFit(true)
        tipL.attributedText = tips
        container.addSubview(tipL)
            
        
        // layout
        
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(240)
        }
        
        container.snp.makeConstraints { make in
            make.width.equalTo(260)
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(40)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 88, height: 88))
            make.top.centerX.equalToSuperview()
        }
        
        contentL.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(70)
        }
        
        tipL.snp.makeConstraints { make in
            make.left.right.equalTo(contentL)
            make.top.greaterThanOrEqualTo(contentL.snp.bottom).offset(10)
            make.bottom.equalTo(-35)
        }
    }
    
    
    
    
    override func widthAdaptePercent() -> CGFloat {
        return 260 / screenWidth
    }
    
    class func contentAttr(_ content: String) -> ATTR {
        return Common.attr(content, textColor: Color.orangeText, font: .semibold(18))
    }
    
    class func tipsAttr(_ tips: String) -> ATTR {
        return Common.attr(tips, textColor: Color.subText, font: .system(14))
    }
    
}
