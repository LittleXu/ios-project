//
//  MovieCommentsViewController.swift
//  ios-project
//
//  Created by liuxu on 2025/1/15.
//

import Foundation
import UIKit
import ObjectMapper
class MovieCommentsViewController: BaseTableViewController {
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        navigationItem.title = movie.title + "的评论"
        setupViews()
        handleCommentDatas()
    }
    
    private func setupViews() {
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.register(CommentCell.self)
        table.separatorStyle = .singleLine
        table.separatorColor = Color.subText
        table.separatorInset = UIEdgeInsets.zero
    }
    
    private func handleCommentDatas() {
        view.showLoading()
        Common.fetch { [weak self] in
            guard let self = self else { return }
            let jsons = Common.parseJSON2Array(fileName: "comments")
            let datas = Mapper<Comment>().mapArray(JSONArray: jsons)
            let random = Int.random(in: 1...10) + 10
            var result = datas.shuffled().prefix(random).shuffled()
            result = result.map({ comment in
                comment.from = self.movie.title + " 短评"
                return comment
            })
            view.hideLoading()
            self.datas = result.shuffled()
            self.table.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.cellID(), for: indexPath) as! CommentCell
        cell.model = self.datas[indexPath.row] as? Comment
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.datas[indexPath.row] as! Comment
        let sheet = UIAlertController(style: .actionSheet, title: "请选择操作")
        sheet.addAction(UIAlertAction(title: "赞同", style: .default, handler: { _ in
            self.view.showToast("已赞同!")
            model.vote_count = "\(model.vote_count.intValue + 1)"
            self.table.reloadRows(at: [indexPath], with: .none)
        }))
        sheet.addAction(UIAlertAction(title: "回复", style: .default, handler: { _ in
            let vc = ReplyCommentsViewController()
            vc.comment = model
            Common.push(vc)
        }))
        sheet.addAction(UIAlertAction(title: "举报", style: .destructive, handler: { _ in
            let vc = ReportCommentsViewController()
            vc.comment = model
            Common.push(vc)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        self.present(sheet, animated: true)
        
    }
    
}
