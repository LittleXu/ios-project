//
//  MeViewController.swift
//  ios-project
//
//  Created by liuxu on 2025/1/15.
//

import Foundation
import UIKit
import FDFullscreenPopGesture
class MeViewController: BaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        fd_prefersNavigationBarHidden = true
        
        setupViews()
    }
    
    private func setupViews() {
        table.register(BaseTextCell.self)
        table.rowHeight = 44
        table.separatorStyle = .singleLine
        table.separatorColor = Color.subText
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    override func setupTableHeaderViews() {
        super.setupTableHeaderViews()
        
        let imageView = UIImageView(image: UIImage(contentsOfFile: Bundle.main.path(forResource: "poster", ofType: "jpg")!)!)
        imageView.contentMode = .scaleAspectFill
        tableHeaderView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
            make.width.equalTo(screenWidth)
            make.height.equalTo(300)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, screenWidth, 44))
        header.backgroundColor = Color.background
        
        let label = UILabel()
            .text(section == 0 ? "我的" : "系统")
            .textColor(Color.text)
            .font(.semibold(18))
        header.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        return header
    }
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTextCell.cellID(), for: indexPath) as! BaseTextCell
        
        var title = ""
        var content = ""
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                title = "我的想看"
                content = "我收藏的电影"
            } else if indexPath.row == 1 {
                title = "我的评论"
                content = "过去发表的评论"
            } else if indexPath.row == 2 {
                title = "我的回复"
                content = "我对于评论的回复"
            } else if indexPath.row == 3 {
                title = "我的举报"
                content = "我举报的不适言论"
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                title = "EULA"
                content = "用户服务协议"
            } else if indexPath.row == 1 {
                title = "关于我们"
                content = "联系我们"
            } else if indexPath.row == 2 {
                title = "版本号"
                content = Bundle.main.releaseVersionNumberPretty
            }
        }
        cell.titleLabel.text = title
        cell.contentLabel.text = content
        cell.titleLabel.textColor = Color.text
        cell.contentLabel.textColor = Color.subText
        cell.contentLabel.font = .system(12)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let vc = MyWantSeeViewController()
                Common.push(vc)
            } else if indexPath.row == 1 {
                let vc = MyReplyViewController()
                vc.type = .comment
                Common.push(vc)
            } else if indexPath.row == 2 {
                let vc = MyReplyViewController()
                vc.type = .reply
                Common.push(vc)
            } else if indexPath.row == 3 {
                let vc = MyReplyViewController()
                vc.type = .report
                Common.push(vc)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: "eula", ofType: "html")!)
                Common.openWeb(url)
            } else if indexPath.row == 1 {
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: "about_us", ofType: "html")!)
                Common.openWeb(url)
            }
        }
    }
}

extension MeViewController: RootViewControllerDelegate {
    func root_viewWillDidAppear() {
        
    }
    
    func root_viewWillDisappear() {
        
    }
    
    
}
