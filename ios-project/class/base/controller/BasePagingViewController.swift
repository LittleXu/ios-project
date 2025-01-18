//
//  BaseRefreshPagingViewController.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/1.
//

import Foundation
import JXPagingView
import JXSegmentedView
import UIKit
import FDFullscreenPopGesture

protocol PagingChildrenDelegate {
    func childAppear()
}


class BaseNormalPagingViewController: BaseViewController {
    
    var pager: JXPagingView!
    var segmented: JXSegmentedView!
    
    var header: UIView = UIView() {
        didSet {
            pager.reloadData()
        }
    }
    /// 这个一定要通过属性强持有, 否则无法显示
    var titleDataSource: JXSegmentedTitleDataSource!
       
    var titles: [String] = [] {
        didSet {
            titleDataSource.titles = titles
            
            // 判断是否有长title的情况
            var maxOffset: CGFloat = 0
            _ = titles.map({ string -> String in
                let widthNormal = string.sizeFor(maxW: CGFloat(MAXFLOAT), maxH: 0, font: titleDataSource.titleNormalFont).width
                let widthSelect = string.sizeFor(maxW: CGFloat(MAXFLOAT), maxH: 0, font: (titleDataSource.titleSelectedFont ?? titleDataSource.titleNormalFont)).width
                
                if widthSelect - widthNormal > maxOffset {
                    maxOffset = widthSelect - widthNormal
                }
                return string
            })
            
            titleDataSource.itemSpacing = maxOffset > 20 ? maxOffset : 20
            
            segmented.reloadData()
        }
    }
    
    var controllers: [JXPagingViewListViewDelegate] = [] {
        didSet {
            pager.reloadData()
        }
    }
    
    var pinSectionHeaderVerticalOffset = 0 {
        didSet {
            pager.pinSectionHeaderVerticalOffset = pinSectionHeaderVerticalOffset
            pager.reloadData()
        }
    }
    
    var defaultSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPager()
    }
    
 
    private func setupPager() {
        pager = JXPagingView(delegate: self)
        pager.automaticallyDisplayListVerticalScrollIndicator = false
        if #available(iOS 15.0, *) {
            pager.mainTableView.sectionHeaderTopPadding = 0
        }
        add(pager)
        
        pager.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        let result = Common.pagerTitleView(CGRect(x: 0, y: 0, width: screenWidth, height: 40), titles: titles, delegate: self, listContainer: pager.listContainerView)
        segmented = result.0
        titleDataSource = result.1
        
        handleGestureRequire(toFail: pager.listContainerView.scrollView.panGestureRecognizer)
        
        if defaultSelectedIndex > 0 {
            pager.defaultSelectedIndex = 1
            segmented.defaultSelectedIndex = 1
        }
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        return controllers[index]
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return Int(header.height)
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return header
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(segmented.height)
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmented
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return controllers.count
    }
    
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {}
    
    func segmentedViewdidSelectedItem(at index: Int) {
        fd_interactivePopDisabled = (index != 0)
    }
    

}

func handleGestureRequire(toFail gesture: UIGestureRecognizer) {
    gesture.require(toFail: gesture)
}

extension BaseNormalPagingViewController: JXPagingViewDelegate {
  
}

extension BaseNormalPagingViewController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        segmentedViewdidSelectedItem(at: index)
        if let controller = controllers[index] as? PagingChildrenDelegate {
            controller.childAppear()
        }
    }
    
    var itemSpacing: CGFloat {
        return 10
    }
}



class BaseRefreshPagingViewController: BaseViewController {
    
    var pager: JXPagingListRefreshView!
    var segmented: JXSegmentedView!
    
    var header: UIView = UIView() {
        didSet {
            pager.reloadData()
        }
    }
    /// 这个一定要通过属性强持有, 否则无法显示
    var titleDataSource: JXSegmentedTitleDataSource!
       
    var titles: [String] = [] {
        didSet {
            titleDataSource.titles = titles
            
            // 判断是否有长title的情况
            var maxOffset: CGFloat = 0
            _ = titles.map({ string -> String in
                let widthNormal = string.sizeFor(maxW: CGFloat(MAXFLOAT), maxH: 0, font: titleDataSource.titleNormalFont).width
                let widthSelect = string.sizeFor(maxW: CGFloat(MAXFLOAT), maxH: 0, font: (titleDataSource.titleSelectedFont ?? titleDataSource.titleNormalFont)).width
                
                if widthSelect - widthNormal > maxOffset {
                    maxOffset = widthSelect - widthNormal
                }
                return string
            })
            
            titleDataSource.itemSpacing = maxOffset > 20 ? maxOffset : 20
            
            segmented.reloadData()
        }
    }
    
    var controllers: [JXPagingViewListViewDelegate] = [] {
        didSet {
            pager.reloadData()
        }
    }
    
    var pinSectionHeaderVerticalOffset = 0 {
        didSet {
            pager.pinSectionHeaderVerticalOffset = pinSectionHeaderVerticalOffset
            pager.reloadData()
        }
    }
    
    var defaultSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPager()
    }
    
 
    private func setupPager() {
        pager = JXPagingListRefreshView(delegate: self)
        pager.automaticallyDisplayListVerticalScrollIndicator = false
        if #available(iOS 15.0, *) {
            pager.mainTableView.sectionHeaderTopPadding = 0
        }
        add(pager)
        
        pager.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        let result = Common.pagerTitleView(CGRect(x: 0, y: 0, width: screenWidth, height: 40), titles: titles, delegate: self, listContainer: pager.listContainerView)
        segmented = result.0
        titleDataSource = result.1
        
        handleGestureRequire(toFail: pager.listContainerView.scrollView.panGestureRecognizer)
        
        if defaultSelectedIndex > 0 {
            pager.defaultSelectedIndex = 1
            segmented.defaultSelectedIndex = 1
        }
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        return controllers[index]
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return Int(header.height)
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return header
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(segmented.height)
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmented
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return controllers.count
    }
    
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {}
    
    func segmentedViewdidSelectedItem(at index: Int) {
        fd_interactivePopDisabled = (index != 0)
    }
}

extension BaseRefreshPagingViewController: JXPagingViewDelegate {
  
}

extension BaseRefreshPagingViewController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        segmentedViewdidSelectedItem(at: index)
        if let controller = controllers[index] as? PagingChildrenDelegate {
            controller.childAppear()
        }
    }
    
    var itemSpacing: CGFloat {
        return 10
    }
}
