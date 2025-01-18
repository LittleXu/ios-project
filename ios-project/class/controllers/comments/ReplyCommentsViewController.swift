//
//  ReplyCommentsViewController.swift
//  ios-project
//
//  Created by liuxu on 2025/1/14.
//

import Foundation
import IQKeyboardManagerSwift




extension Common {

    static let reply_key = "reply_key"
    static func saveCommentReply(comment_content: String, from: String, content: String, isReport: Bool = false, isMovie: Bool = false) {
        
        let reply = CommentReply()
        reply.comment_content = comment_content
        reply.comment_from = from
        reply.content = content
        reply.isReport = isReport
        reply.time = Common.dateFormatter().string(from: Date())
        reply.isMovie = isMovie
        
        let json = reply.toJson()
        if var array = UserDefaults.standard.value(forKey: reply_key) as? [[String: Any]] {
            array.insert(json, at: 0)
            UserDefaults.standard.set(array, forKey: reply_key)
        } else {
            UserDefaults.standard.set([json], forKey: reply_key)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    static func selectCommentReplys() -> [CommentReply] {
        if var array = UserDefaults.standard.value(forKey: reply_key) as? [[String: Any]] {
            array = array.filter({ item in
                let isReport = item["isReport"] as? Bool ?? false
                let isMovie = item["isMovie"] as? Bool ?? false
                return !isReport && !isMovie
            })
            
            let results = array.map { item in
                return CommentReply.init(json: item)
            }
            return results
        }
        return []
    }
    
    static func selectCommentReports() -> [CommentReply] {
        if var array = UserDefaults.standard.value(forKey: reply_key) as? [[String: Any]] {
            array = array.filter({ item in
                let isReport = item["isReport"] as? Bool ?? false
                let isMovie = item["isMovie"] as? Bool ?? false

                return isReport && !isMovie
            })
            
            let results = array.map { item in
                return CommentReply.init(json: item)
            }
            
            return results
        }
        return []
    }
    
    static func selectMovieComments() -> [CommentReply] {
        if var array = UserDefaults.standard.value(forKey: reply_key) as? [[String: Any]] {
            array = array.filter({ item in
                let isMovie = item["isMovie"] as? Bool ?? false
                return isMovie
            })
            let results = array.map { item in
                return CommentReply.init(json: item)
            }
            return results
        }
        return []
    }
    
}


class ReplyCommentsViewController: BaseTableViewController {
    
    var comment: Comment!
    
    private var quoteView: QuoteCommentView!
    
    private var tipLabel: UILabel!
    private var maxLabel: UILabel!
    private var textView: IQTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func setupTableHeaderViews() {
        super.setupTableHeaderViews()
        
        quoteView = QuoteCommentView(comment: comment)
        tableHeaderView.addSubview(quoteView)
        
        tipLabel = UILabel()
            .text("回复评论")
            .font(.system(15))
            .textColor(Color.subText)
        tableHeaderView.addSubview(tipLabel)
        
        textView = IQTextView(frame: CGRectMake(0, 0, screenWidth - 32, 200))
        textView.backgroundColor = Color.lightBackground
        textView.layer.cornerRadius = 16
        textView.clipsToBounds = true
        textView.placeholder = "请输入"
        textView.font = .system(12)
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        tableHeaderView.addSubview(textView)
        
        maxLabel = UILabel()
            .text("限制200字以内")
            .font(.system(12))
            .textColor(Color.subText)
        tableHeaderView.addSubview(maxLabel)
        
        // layout
        quoteView.snp.makeConstraints { make in
            make.left.top.equalTo(16)
            make.width.equalTo(screenWidth - 32)
            make.right.equalTo(-16)
        }
        
        tipLabel.snp.makeConstraints { make in
            make.left.right.equalTo(quoteView)
            make.top.equalTo(quoteView.snp.bottom).offset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.size.equalTo(textView.frame.size)
            make.top.equalTo(tipLabel.snp.bottom).offset(8)
            make.left.equalTo(quoteView)
        }
        
        maxLabel.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.bottom.equalTo(-16)
        }
    }
    
    private func setupViews() {
        navigationItem.title = "回复评论"
        _ = setupBottomButton(title: "回复") { [weak self] in
            guard let self = self else { return }
            guard let text = self.textView.text, text.isNotEmpty else {
                Common.showToast("请输入内容!")
                return
            }
            // 回复评论
            Common.showLoading()
            Common.fetch {
                Common.hideLoading()
                Common.showToast("回复成功! 将在审核通过后展示!")
                Common.saveCommentReply(comment_content: self.comment.comment_content, from: self.comment.from, content: text)
            }
        }
    }
    
}
