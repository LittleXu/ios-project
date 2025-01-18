platform :ios, '15.0'
target 'ios-project' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Moya'
  pod 'MJRefresh'
  pod 'SnapKit'
  pod 'JXPagingView/Paging'
  pod 'JXSegmentedView'
  pod 'Kingfisher'
  pod 'Toast-Swift'
  pod 'ObjectMapper'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'IQKeyboardManagerSwift'
  pod 'Reachability'
  pod 'TTTAttributedLabel'
  # 图片浏览器
  pod 'Lantern'
  # 图片选择器
  pod 'ZLPhotoBrowser', '~> 4.5.6'
  # 验证码输入框
  pod 'CRBoxInputView'
  # 信息展示弹窗
  pod 'NotificationBannerSwift'
  # 轮播图
  pod 'TYCyclePagerView'
  # 路由管理
  pod 'URLNavigator'
  # LOG
  pod 'Log'
  # 弹窗视图
  pod 'TYAlertController'
  # 纵向的跑马灯效果
  pod 'SDCycleScrollView'
  pod 'YYText'
  pod 'FDFullscreenPopGesture'
end

  
 
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
               end
          end
   end
end

       
