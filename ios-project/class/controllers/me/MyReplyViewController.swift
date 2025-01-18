//
//  MyReplyViewController.swift
//  ios-project
//
//  Created by liuxu on 2025/1/15.
//

import Foundation
import UIKit

enum ReplyTypeEnum {
    case comment
    case reply
    case report
    
    func title() -> String {
        switch self {
        case .comment:
            return "我的评论"
        case .reply:
            return "我的回复"
        case .report:
            return "我的举报"
        }
    }
    
    func data() -> [CommentReply] {
        switch self {
        case .comment:
            return Common.selectMovieComments()
        case .reply:
            return Common.selectCommentReplys()
        case .report:
            return Common.selectCommentReports()
        }
    }
}

class MyReplyViewController: BaseTableViewController {
    // 1 我的评论 2 我的回复 3 我的举报
    var type = ReplyTypeEnum.comment
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = type.title()
        setupViews()
        handleDatas()
    }
    
    private func setupViews() {
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.register(ReplyCell.self)
        table.separatorStyle = .singleLine
        table.separatorColor = Color.subText
        table.separatorInset = UIEdgeInsets.zero
    }
    
    private func handleDatas() {
        Common.showLoading()
        Common.fetch {
            Common.hideLoading()
            self.datas = self.type.data()
            self.table.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReplyCell.cellID(), for: indexPath) as! ReplyCell
        cell.model = self.datas[indexPath.row] as? CommentReply
        return cell
    }
    
}
