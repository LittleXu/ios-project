//
//  BaseTableViewController.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/16.
//

import Foundation
import UIKit
import RxSwift

class BaseTableViewController: BaseViewController {
    
    var pageNumber: Int = 1
    
    lazy var table: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: tableViewStyle())
        table.contentInsetAdjustmentBehavior = .never
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.register(all: [BaseTableViewCell.self])
        table.rowHeight = BaseTableViewCell.rowHeight()
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        return table
    }()
    
    var tableHeaderView: UIView!
    var datas: [Any] = []
    var emptySuperView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.background

        
        setupViews()
        setupTableHeaderViews()
        finishTableHeaderViews()
    }
    
    
    func resetTableHeaderViews() {
        setupTableHeaderViews()
        finishTableHeaderViews()
    }
    
    func setupTableHeaderViews() {
        tableHeaderView = UIView()
        tableHeaderView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
        }
    }
    
    func finishTableHeaderViews() {
        if tableHeaderView.subviews.isNotEmpty {
            let size = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            tableHeaderView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            table.tableHeaderView = tableHeaderView
        }
    }
    
    private func setupViews() {
        add(table)
        
        emptySuperView = table
        // layout
        table.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalTo(0)
        }
    }
    
    func tableViewStyle() -> UITableView.Style {
        return .plain
    }
    
    func addHeader(_ block: @escaping B) {
        table.addHeader {
            self.pageNumber = 1
            block()
        }
    }
    
    func addFooter(_ block: @escaping B) {
        table.addFooter {
            self.pageNumber += 1
            block()
        }
    }
    
    func addRefresh(_ block: @escaping B) {
        addHeader(block)
        addFooter(block)
    }
    
    func handle(datas:[Any]) {
        table.stopHeader()
        if datas.count < APIManager.pagesize { table.stopFooter() } else { table.stopFooterWithNoMoreData() }
        if self.pageNumber == 1 {
            self.datas = datas
        } else {
            self.datas.append(contentsOf: datas)
        }
        self.table.reloadData()
    }
}

extension BaseTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.cellID(), for: indexPath) as! BaseTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}


extension BaseTableViewController {
    
    func setupBottomButton(title: String, action: B?) -> UIButton {
        let button = UIButton.colorBackgroundButton(title, action: action)
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.bottom.equalTo(-16 - bottomSafeAreaHeight)
            make.height.equalTo(58)
        }
        
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16 + bottomSafeAreaHeight + 58 + 16, right: 0)
        return button
    }
    
}


extension UITableView {
    
    func commonSeparatorStyle(_ color: UIColor = Color.separator, edge: UIEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)) {
        self.separatorStyle = .singleLine
        self.separatorColor = color
        self.separatorInset = edge
    }
    
}
