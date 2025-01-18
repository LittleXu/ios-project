//
//  TextSheetPopupView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/1.
//

import Foundation
import UIKit


class TextSheetPopupView: BasePopupView {
    
    private var title = ""
    private var actions: [BaseCellModelProtocol] = []
    
    private var table: UITableView!
    private var titleL: UILabel!
    private var closeB: UIButton!
    
    convenience init(_ title: String, actions: [BaseCellModelProtocol]) {
        self.init()
        self.title = title
        self.actions = actions
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = Color.background
        var count = actions.count
        if count > 5 { count = 5 }
        let height = 34 + CGFloat(50 + 44 * count)
        frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        corner(corners: [.topLeft, .topRight], radius: 15)
        
        titleL = UILabel()
            .text(title)
            .textColor(Color.text)
            .font(.semibold(17))
            .sizeToFit(true)
        addSubview(titleL)
        
        closeB = UIButton()
            .normalImage(UIImage(named: "icon_close_lightgray"))
            .action({ [weak self] _ in
                self?.dismiss()
            })
        addSubview(closeB)
        
        table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = Color.background
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 44
        table.tableFooterView = UIView()
        table.isScrollEnabled = actions.count > 5
        table.register(all: [BaseTextCell.self, BaseTextSwitchCell.self])
        table.commonSeparatorStyle()
        addSubview(table)
        
        titleL.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.height.equalTo(21)
            make.top.equalTo(18)
            make.right.lessThanOrEqualTo(closeB.snp.left).offset(-15)
        }
        
        closeB.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 44, height: 44))
            make.right.equalToSuperview()
            make.centerY.equalTo(titleL)
        }
        
        table.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-34)
            make.top.equalTo(50)
        }
    }
    
}

extension TextSheetPopupView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = actions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.cellId, for: indexPath)
        if let cell = cell as? BaseTextCell {
            cell.titleLabel.text = model.title
            return cell
        } else if let cell = cell as? BaseTextSwitchCell {
            cell.model = model as? BaseCellSwitchModel
            cell.titleLabel.textColor = Color.subText
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss { }
        guard let model = self.actions[indexPath.row] as? BaseCellModel else { return }
        model.selectBlock?()
    }
}
