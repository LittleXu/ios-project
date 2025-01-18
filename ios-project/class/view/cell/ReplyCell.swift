//
//  ReplyCell.swift
//  ios-project
//
//  Created by liuxu on 2025/1/15.
//

import Foundation
import UIKit

class ReplyCell: BaseTableViewCell {
    
    var model: CommentReply? {
        didSet {
            guard let model = model else { return }
            sourceTitleLabel.text = model.comment_from
            soureSubtitleLabel.text = model.comment_content
            myCommentLabel.text = "我说: " + model.content
            myCommentTimeLabel.text = "发表于: " + model.time
            statusLabel.text = "审核中..."
        }
    }
    
    private var grayContainerView: UIView!
    private var sourceTitleLabel: UILabel!
    private var soureSubtitleLabel: UILabel!
    
    private var myCommentLabel: UILabel!
    private var myCommentTimeLabel: UILabel!
    private var statusLabel: UILabel!
    
    override func setupViews() {
        super.setupViews()
        
        grayContainerView = UIView()
            .bgColor(Color.lightBackground)
            .cornerRadius(16)
        contentView.addSubview(grayContainerView)
        
        sourceTitleLabel = UILabel()
            .textColor(Color.text)
            .font(.system(15))
        
        soureSubtitleLabel = UILabel()
            .textColor(Color.subText)
            .font(.system(12))
        
        grayContainerView.appendSubviews(with: [sourceTitleLabel, soureSubtitleLabel])
        
        myCommentLabel = UILabel()
            .textColor(Color.text)
            .font(.system(15))
            .numOfLines(0)
        
        myCommentTimeLabel = UILabel()
            .textColor(Color.subText)
            .font(.system(12))
        
        statusLabel = UILabel()
            .textColor(Color.systemGreen)
            .font(.system(12))
        
        contentView.appendSubviews(with: [myCommentLabel, myCommentTimeLabel, statusLabel])
        
        // layout
        grayContainerView.snp.makeConstraints { make in
            make.left.top.equalTo(16)
            make.right.equalTo(-16)
        }
        
        sourceTitleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(16)
            make.right.equalTo(-16)
        }
        
        soureSubtitleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(sourceTitleLabel)
            make.top.equalTo(sourceTitleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(-16)
        }
        
        myCommentLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(grayContainerView.snp.bottom).offset(16)
        }
        
        myCommentTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(myCommentLabel.snp.bottom).offset(8)
            make.bottom.equalTo(-16)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(myCommentTimeLabel)
        }
    }
    
}
