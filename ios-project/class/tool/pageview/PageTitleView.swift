//
//  PageTitleView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/29.
//

import Foundation
import JXPagingView
import UIKit
import JXSegmentedView

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

extension Common {
    // 顶部悬浮
    static func pagerTitleView(
        _ frame: CGRect,
        titles: [String],
        delegate: JXSegmentedViewDelegate,
        listContainer: JXSegmentedViewListContainer? = nil,
        normalColor: UIColor = Color.subText,
        selectColor: UIColor = Color.orangeText,
        normalFont: UIFont = .system(13),
        selectFont: UIFont = .semibold(16),
        indicatorColor: UIColor = Color.orangeText,
        indicatorWidth: CGFloat = 11,
        indicatorHeight: CGFloat = 4,
        indicatorRadius: CGFloat = 2
    ) -> (JXSegmentedView, JXSegmentedTitleDataSource) {
        let segmented = JXSegmentedView()
        segmented.frame = frame
        segmented.collectionView.isScrollEnabled = false
        
        let titleDataSource = JXSegmentedTitleDataSource()
        titleDataSource.titles = titles
        titleDataSource.titleNormalColor = normalColor
        titleDataSource.titleSelectedColor = selectColor
        titleDataSource.titleNormalFont = normalFont
        titleDataSource.titleSelectedFont = selectFont
        titleDataSource.isTitleZoomEnabled = false
        titleDataSource.isItemSpacingAverageEnabled = false

        segmented.backgroundColor = Color.background
        segmented.delegate = delegate
        segmented.dataSource = titleDataSource
        segmented.isContentScrollViewClickTransitionAnimationEnabled = false

        
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = indicatorColor
        lineView.indicatorWidth = indicatorWidth
        lineView.indicatorHeight = indicatorHeight
        lineView.indicatorCornerRadius = indicatorRadius
        segmented.indicators = [lineView]
        
        if let listContainer = listContainer {
            segmented.listContainer = listContainer
        }
        
        return (segmented, titleDataSource)
    }
    
    static func indicator(
        _ indicatorColor: UIColor = Color.theme,
        indicatorWidth: CGFloat = 18,
        indicatorHeight: CGFloat = 3,
        indicatorRadius: CGFloat = 1.5
    ) -> JXSegmentedIndicatorLineView {
        
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = indicatorColor
        lineView.indicatorWidth = indicatorWidth
        lineView.indicatorHeight = indicatorHeight
        lineView.indicatorCornerRadius = indicatorRadius
        return lineView
    }
    
}

