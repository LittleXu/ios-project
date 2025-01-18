//
//  TableView+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/22.
//

import Foundation
import UIKit
import MJRefresh

extension UITableView {
    func register(all classess: [UIView.Type]) {
        _ = classess.map { type in
            if let type = type as? UITableViewCell.Type {
                register(type)
            }
            
            if let type = type as? UITableViewHeaderFooterView.Type {
                register(headerFooter: type)
            }
        }
    }
    
    func register(cells classess: [UITableViewCell.Type]) {
        _ = classess.map { type in
            self.register(type)
        }
    }
    
    func register(_ cell: UITableViewCell.Type) {
        register(cell.self, forCellReuseIdentifier: cell.cellID())
    }
    
    func register(headerFooters classess: [UITableViewHeaderFooterView.Type]) {
        _ = classess.map({ type in
            self.register(headerFooter: type)
        })
    }
    
    func register(headerFooter type: UITableViewHeaderFooterView.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: type.viewID())
    }
}

extension UICollectionView {
    func register(all classess: [UIView.Type]) {
        _ = classess.map { type in
            if let type = type as? UICollectionViewCell.Type {
                register(type)
            }
            
            if let type = type as? BaseCollectionReusabelView.Type {
                register(headerFooter: type)
            }
        }
    }
    
    func register(cells classess: [UICollectionViewCell.Type]) {
        _ = classess.map { type in
            self.register(type)
        }
    }
    
    func register(_ cell: UICollectionViewCell.Type) {
        register(cell.self, forCellWithReuseIdentifier: cell.cellID())
    }
    
    func register(headerFooters classess: [BaseCollectionReusabelView.Type]) {
        _ = classess.map({ type in
            self.register(headerFooter: type)
        })
    }
    
    func register(headerFooter type: BaseCollectionReusabelView.Type) {
        register(type, forSupplementaryViewOfKind: type.kind(), withReuseIdentifier: type.viewID())
    }
}



/// refresh

extension UIScrollView {
    
    func addHeader(_ completion: B? = nil) {
        if let _ = mj_header { return }
       
        let header = MJRefreshNormalHeader(refreshingBlock: {
            completion?()
        })
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        header.loadingView?.style = .medium
        mj_header = header
    }
    
    func addFooter(_ completion: B? = nil) {
        if let _ = mj_footer { return }
        let footer = MJRefreshBackStateFooter(refreshingBlock: {
            completion?()
        })
        footer.setTitle("", for: .noMoreData)
        footer.setTitle("", for: .idle)
        mj_footer = footer
    }
    
    func stop() {
        stopHeader()
        stopFooter()
    }
    
    func stopHeader() {
        if let header = mj_header, header.isRefreshing {
            header.endRefreshing()
        }
    }
    
    func stopFooter() {
        if let footer = mj_footer, footer.isRefreshing {
            footer.endRefreshing()
        }
    }
    
    func stopFooterWithNoMoreData() {
        if let footer = mj_footer, footer.isRefreshing {
            footer.endRefreshingWithNoMoreData()
        }
    }
    
    func startHeader() {
        stopFooter()
        if let header = mj_header, !header.isRefreshing {
            header.beginRefreshing()
        }
    }
    
    func startFooter() {
        stopHeader()
        if let footer = mj_footer, !footer.isRefreshing {
            footer.beginRefreshing()
        }
    }
}
