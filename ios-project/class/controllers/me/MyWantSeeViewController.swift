//
//  MyWantSeeViewController.swift
//  ios-project
//
//  Created by liuxu on 2025/1/15.
//

import Foundation
import UIKit
class MyWantSeeViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        navigationItem.title = "我的想看"
        setupViews()
        handleMovieDatas()
    }
    
    private func setupViews() {
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 170 + 32
        table.register(MovieCell.self)
        table.separatorStyle = .singleLine
        table.separatorColor = Color.subText
        table.separatorInset = UIEdgeInsets.zero
    }
    
    private func handleMovieDatas() {
        view.showLoading()
        Common.fetch { [weak self] in
            guard let self = self else { return }
            view.hideLoading()
            self.datas = Common.selectWantSeeMovies()
            self.table.reloadData()
            if (datas.isEmpty) {
                Common.showToast("暂无数据!")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.cellID(), for: indexPath) as! MovieCell
        cell.movie = datas[indexPath.row] as? Movie
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.datas[indexPath.row] as! Movie
        let sheet = UIAlertController(style: .actionSheet, title: "请选择操作")
        sheet.addAction(UIAlertAction(title: "取消想看", style: .default, handler: { _ in
            Common.showToast("已取消!")
            Common.cancelWantSee(movie: model)
            self.datas.remove(at: indexPath.row)
            self.table.reloadData()
        }))
        sheet.addAction(UIAlertAction(title: "发表评论", style: .default, handler: { _ in
            let vc = MovieReplyViewController()
            vc.movie = model
            Common.push(vc)
        }))
        sheet.addAction(UIAlertAction(title: "查看评论", style: .default, handler: { _ in
            let vc = MovieCommentsViewController()
            vc.movie = model
            Common.push(vc)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        self.present(sheet, animated: true)
    }
}
