//
//  CommentCell.swift
//  ios-project
//
//  Created by liuxu on 2025/1/14.
//

import Foundation
import UIKit

extension UIImageView {
    func setLocalImage(with name: String) {
        if let path = Bundle.main.path(forResource: name, ofType: nil), let image = UIImage(contentsOfFile: path) {
            self.image = image
        }
    }
}

class CommentCell: BaseTableViewCell {
    
    var model: Comment? {
        didSet {
            guard let model = model else { return }
            avatarImageView.setLocalImage(with: model.avatar)
            nickNameLabel.text = model.nick_name
            timeLabel.text = model.comment_time
            locationLabel.text = "发表于: " + (model.comment_location.isNotEmpty ? model.comment_location : "火星")
            contentLabel.attributedText = Common.attr(model.comment_content, textColor: Color.text, align: .left)
            fromLabel.text = model.from
            voteLabel.text = model.vote_count + "人赞同"
            
            if model.rating == 0 {
                starImageView1.isHidden = true
                starImageView2.isHidden = true
                starImageView3.isHidden = true
                starImageView4.isHidden = true
                starImageView5.isHidden = true
                starTextLabel.text = "极差"
            } else if model.rating == 1 {
                starImageView1.isHidden = false
                starImageView2.isHidden = true
                starImageView3.isHidden = true
                starImageView4.isHidden = true
                starImageView5.isHidden = true
                starTextLabel.text = "较差"
            } else if model.rating == 2 {
                starImageView1.isHidden = false
                starImageView2.isHidden = false
                starImageView3.isHidden = true
                starImageView4.isHidden = true
                starImageView5.isHidden = true
                starTextLabel.text = "一般"
            } else if model.rating == 3 {
                starImageView1.isHidden = false
                starImageView2.isHidden = false
                starImageView3.isHidden = false
                starImageView4.isHidden = true
                starImageView5.isHidden = true
                starTextLabel.text = "还行"
            } else if model.rating == 4 {
                starImageView1.isHidden = false
                starImageView2.isHidden = false
                starImageView3.isHidden = false
                starImageView4.isHidden = false
                starImageView5.isHidden = true
                starTextLabel.text = "推荐"
            } else {
                starImageView1.isHidden = false
                starImageView2.isHidden = false
                starImageView3.isHidden = false
                starImageView4.isHidden = false
                starImageView5.isHidden = false
                starTextLabel.text = "很棒"
            }
        }
    }
    
    private var avatarImageView: UIImageView!
    private var nickNameLabel: UILabel!
    private var timeLabel: UILabel!
    private var locationLabel: UILabel!
    private var voteLabel: UILabel!
    private var contentLabel: UILabel!
    private var fromLabel: UILabel!
    private var starTextLabel: UILabel!
    
    private var starImageView1: UIImageView!
    private var starImageView2: UIImageView!
    private var starImageView3: UIImageView!
    private var starImageView4: UIImageView!
    private var starImageView5: UIImageView!
    
    override func setupViews() {
        super.setupViews()
        
        avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFit
        contentView.addSubview(avatarImageView)
        
        nickNameLabel = UILabel()
            .textColor(Color.text)
            .font(.system(15))
        contentView.addSubview(nickNameLabel)
        
        timeLabel = UILabel()
            .textColor(Color.subText)
            .font(.system(12))
        contentView.addSubview(timeLabel)
        
        locationLabel = UILabel()
            .textColor(Color.subText)
            .font(.system(12))
        contentView.addSubview(locationLabel)
        
        
        starImageView1 = UIImageView(image: UIImage(named: "icon_star"))
        starImageView2 = UIImageView(image: UIImage(named: "icon_star"))
        starImageView3 = UIImageView(image: UIImage(named: "icon_star"))
        starImageView4 = UIImageView(image: UIImage(named: "icon_star"))
        starImageView5 = UIImageView(image: UIImage(named: "icon_star"))
        contentView.appendSubviews(with: [starImageView1, starImageView2, starImageView3, starImageView4, starImageView5])
        
        starTextLabel = UILabel()
            .textColor(Color.subText)
            .font(.system(12))
        contentView.addSubview(starTextLabel)
        
        contentLabel = UILabel()
            .textColor(Color.text)
            .font(.system(15))
            .numOfLines(0)
        contentView.addSubview(contentLabel)
        
        fromLabel = UILabel()
            .textColor(Color.subText)
            .font(.system(12))
        contentView.addSubview(fromLabel)
        
        voteLabel = UILabel()
            .textColor(Color.subText)
            .font(.system(12))
        contentView.addSubview(voteLabel)
        
        // layout
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.left.top.equalTo(16)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(8)
            make.top.equalTo(avatarImageView)
            make.right.equalTo(-16)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.left.equalTo(nickNameLabel)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(locationLabel.snp.right).offset(4)
            make.right.lessThanOrEqualTo(-16)
            make.centerY.equalTo(locationLabel)
        }
        
        starTextLabel.snp.makeConstraints { make in
            make.left.equalTo(locationLabel)
            make.top.equalTo(locationLabel.snp.bottom).offset(4)
        }
        
        starImageView1.snp.makeConstraints { make in
            make.left.equalTo(starTextLabel.snp.right).offset(4)
            make.width.height.equalTo(15)
            make.centerY.equalTo(starTextLabel).offset(1)
        }
        
        starImageView2.snp.makeConstraints { make in
            make.size.centerY.equalTo(starImageView1)
            make.left.equalTo(starImageView1.snp.right).offset(4)
        }
                
        starImageView3.snp.makeConstraints { make in
            make.size.centerY.equalTo(starImageView1)
            make.left.equalTo(starImageView2.snp.right).offset(4)
        }
                
        starImageView4.snp.makeConstraints { make in
            make.size.centerY.equalTo(starImageView1)
            make.left.equalTo(starImageView3.snp.right).offset(4)
        }
                
        starImageView5.snp.makeConstraints { make in
            make.size.centerY.equalTo(starImageView1)
            make.left.equalTo(starImageView4.snp.right).offset(4)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
        }
        
        fromLabel.snp.makeConstraints { make in
            make.left.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp.bottom).offset(16)
            make.bottom.equalTo(-16)
        }
        
        voteLabel.snp.makeConstraints { make in
            make.right.equalTo(contentLabel)
            make.centerY.equalTo(fromLabel)
        }
    }
}
