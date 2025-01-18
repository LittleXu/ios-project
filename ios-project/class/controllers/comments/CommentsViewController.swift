//
//  CommentsViewController.swift
//  ios-project
//
//  Created by liuxu on 2025/1/13.
//

import UIKit
import ObjectMapper

extension Common {
    static func parseJSON2Array(fileName: String) -> [[String: Any]] {
        // 获取 JSON 文件路径
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "geojson") else {
            print("文件未找到")
            return []
        }
        
        do {
            // 读取文件内容
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath))
            // 使用 JSONDecoder 将数据解析为数组
            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                return jsonArray
            }
            
        } catch {
            print("JSON 解析失败: \(error.localizedDescription)")
        }
        return []
        
    }
}

class CommentsViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        navigationItem.title = "热评"
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
            view.hideLoading()
            self.datas = datas.shuffled()
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


extension CommentsViewController: RootViewControllerDelegate {
    func root_viewWillDidAppear() {
        
    }
    
    func root_viewWillDisappear() {
        
    }
}
