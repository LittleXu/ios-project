//
//  BasePagingChildViewController.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/1.
//

import Foundation
import UIKit
import JXPagingView

class BasePagingChildViewController: BaseTableViewController {
    var scrollBlock: B1<UIScrollView>?
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollBlock?(scrollView)
    }
}

extension BasePagingChildViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return table
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        scrollBlock = callback
    }
}
