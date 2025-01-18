//
//  QuoteCommentView.swift
//  ios-project
//
//  Created by liuxu on 2025/1/14.
//  引用评论

import Foundation
import UIKit

class QuoteCommentView: BaseView {
    
    private var authorLabel: UILabel!
    private var commentLabel: UILabel!
    
    private var comment: Comment!
    private var movie: Movie!
    
    convenience init(comment: Comment) {
        self.init(frame: .zero)
        self.comment = comment
        setupViews()
    }
    
    convenience init(movie: Movie) {
        self.init(frame: .zero)
        self.movie = movie
        setupMovieViews()
    }
    
    private func setupMovieViews() {
        backgroundColor = Color.lightBackground
        cornerRadius(15)
        clipsToBounds = true
        
        authorLabel = UILabel()
            .font(.system(15))
            .textColor(Color.subText)
            .text(movie.title)
        
        commentLabel = UILabel()
            .font(.system(12))
            .textColor(Color.subText)
            .numOfLines(0)
        commentLabel.attributedText = Common.attr("演员: \(movie.actors)", textColor: Color.subText, font: .system(12),  align: .left)
        appendSubviews(with: [authorLabel, commentLabel])
        
        // layout
        authorLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(16)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(authorLabel)
            make.top.equalTo(authorLabel.snp.bottom).offset(8)
            make.bottom.equalTo(-16)
        }
    }
    
    private func setupViews() {
        backgroundColor = Color.lightBackground
        cornerRadius(15)
        clipsToBounds = true
        
        authorLabel = UILabel()
            .font(.system(15))
            .textColor(Color.subText)
            .text("由\(comment.nick_name)发布")
        
        commentLabel = UILabel()
            .font(.system(12))
            .textColor(Color.subText)
            .numOfLines(0)
        commentLabel.attributedText = Common.attr("评论内容: \(comment.comment_content)", textColor: Color.subText, font: .system(12),  align: .left)
        appendSubviews(with: [authorLabel, commentLabel])
        
        // layout
        authorLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(16)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.left.right.equalTo(authorLabel)
            make.top.equalTo(authorLabel.snp.bottom).offset(8)
            make.bottom.equalTo(-16)
        }
    }
    
}
