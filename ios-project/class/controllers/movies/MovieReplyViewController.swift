//
//  MovieReplyViewController.swift
//  ios-project
//
//  Created by liuxu on 2025/1/15.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

class MovieReplyViewController: BaseTableViewController {
    
    var movie: Movie!
    
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
        
        quoteView = QuoteCommentView(movie: movie)
        tableHeaderView.addSubview(quoteView)
        
        tipLabel = UILabel()
            .text("发表评论:")
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
        navigationItem.title = "发表评论"
        _ = setupBottomButton(title: "发表") { [weak self] in
            guard let self = self else { return }
            guard let text = self.textView.text, text.isNotEmpty else {
                Common.showToast("请输入内容!")
                return
            }
            // 回复评论
            Common.showLoading()
            Common.fetch {
                Common.hideLoading()
                Common.showToast("发表成功! 将在审核通过后展示!")
                Common.saveCommentReply(comment_content: self.movie.title, from: self.movie.title + " 短评", content: text, isMovie: true)
            }
        }
    }
    
}
