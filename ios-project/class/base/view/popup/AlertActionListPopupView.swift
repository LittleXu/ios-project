//
//  AlertActionListPopupView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/22.
//  带有关闭按钮的 内容为列表的弹窗视图

import Foundation
import UIKit

struct ListPopupModel {
    var title = ""
    var desc = ""
}

private let maxVisiableRows = 8
private let rowsHeight = 45




class AlertActionListPopupView: BasePopupView {
    
    private var title = ""
    private var datas: [ListPopupModel] = []
    private var actions: [AlertActionModel] = []
    
    private var container: UIView!
    private var closeB: UIButton!
    private var titleL: UILabel!
    private var table: UITableView!
    private var actionButtons: [UIButton] = []
    
    convenience init(_ title: String, datas: [ListPopupModel], actions: [AlertActionModel] = []) {
        self.init()
        self.title = title
        self.datas = datas
        self.actions = actions
        setupViews()
    }
    
    private func setupViews() {
        container = UIView()
            .bgColor(Color.background)
            .cornerRadius(15)
        addSubview(container)
        
        titleL = UILabel()
            .text(title)
            .textColor(Color.text)
            .font(.medium(18))
            .sizeToFit(true)
        container.addSubview(titleL)
        
        closeB = UIButton()
//            .normalImage(R.image.icon_close_lightgray())
            .action({ btn in
                self.dismiss()
            })
        container.addSubview(closeB)
        
        
        var rows = datas.count
        if rows > maxVisiableRows {
            rows = maxVisiableRows
        }
        
        
        table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.commonSeparatorStyle()
        table.rowHeight = CGFloat(rowsHeight)
        container.addSubview(table)
        
        
        for model in actions {
            let button = model.button()
            button.action { _ in
                self.dismiss(block: model.block)
            }
            container.addSubview(button)
            actionButtons.append(button)
        }
        
       
        
        if actions.count == 2 {
            let leftB = actionButtons[0]
            let rightB = actionButtons[1]
            
            let width = (screenWidth * widthAdaptePercent() - 50 - 15) * 0.5
            if leftB.width <= width && rightB.width <= width {
                leftB.snp.makeConstraints { make in
                    make.left.equalTo(25)
                    make.width.equalTo(width)
                    make.top.equalTo(table.snp.bottom).offset(25)
                    make.height.equalTo(38)
                    make.bottom.equalTo(-25)
                }
                
                rightB.snp.makeConstraints { make in
                    make.right.equalTo(-25)
                    make.width.height.equalTo(leftB)
                    make.centerY.equalTo(leftB)
                }
            } else {
                _ = actionButtons.map { button in
                    button.width = screenWidth * self.widthAdaptePercent() - 50
                    button.height = 38
                }
                actionButtons.layout(.vertical, before: table.snp.bottom, leading: 25, center: container.snp.centerX, margin: 15, after: container.snp.bottom, trailing: 25)
            }
        } else if actions.count > 0 {
            _ = actionButtons.map { button in
                button.width = screenWidth * self.widthAdaptePercent() - 50
                button.height = 38
            }
            actionButtons.layout(.vertical, before: table.snp.bottom, leading: 25, center: container.snp.centerX, margin: 15, after: container.snp.bottom, trailing: 25)
        } else {
            table.snp.makeConstraints { make in
                make.bottom.equalTo(-25)
            }
        }
            
        
        // layout
        self.snp.makeConstraints { make in
            make.width.equalTo(screenWidth * widthAdaptePercent())
            make.height.greaterThanOrEqualTo(200)
        }
        
        container.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        titleL.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(15)
            make.top.equalTo(22)
        }
        
        table.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(CGFloat(rows * rowsHeight))
            make.top.equalTo(titleL.snp.bottom).offset(22)
        }
    }
    
    
    override func widthAdaptePercent() -> CGFloat {
        return (screenWidth - 50) / screenWidth
    }
}

extension AlertActionListPopupView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "AlertActionListPopupViewCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellID)
            cell!.textLabel?.textColor = Color.text
            cell!.detailTextLabel?.textColor = Color.subText
            cell!.textLabel?.font = .system(13)
            cell!.detailTextLabel?.font = .system(13)
            cell?.selectionStyle = .none
        }
        
        let model = datas[indexPath.row]
        cell?.textLabel?.text = model.title
        cell?.detailTextLabel?.text = model.desc
        return cell!
    }
}
