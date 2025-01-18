//
//  MovieCell.swift
//  ios-project
//
//  Created by liuxu on 2025/1/15.
//

import Foundation
import UIKit

class MovieCell: BaseTableViewCell {
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            coverImageView.setLocalImage(with: movie.img)
            titleLabel.text = movie.title
            
            let actorsAttr = ("主演: " + movie.actors).toATTRM(with: nil)
            actorsAttr.changeTextColor(movie.actors, color: Color.theme)
            actorsLabel.attributedText = actorsAttr
            
            let directorAttr = ("导演: " + movie.director).toATTRM(with: nil)
            directorAttr.changeTextColor(movie.director, color: Color.theme)
            directorLabel.attributedText = directorAttr
            regionLabel.text = movie.region
            releaseLabel.text = "上映时间: " + movie.release
            durationLabel.text = "片长: " + movie.duration
            voteCountLabel.text = movie.votecount + "人评价"
            
            if movie.score.doubleValue < 2 {
                starImageView1.isHidden = false
                starImageView2.isHidden = true
                starImageView3.isHidden = true
                starImageView4.isHidden = true
                starImageView5.isHidden = true
                scoreLabel.text = "较差"
            } else if movie.score.doubleValue < 4 {
                starImageView1.isHidden = false
                starImageView2.isHidden = false
                starImageView3.isHidden = true
                starImageView4.isHidden = true
                starImageView5.isHidden = true
                scoreLabel.text = "一般"
            } else if movie.score.doubleValue < 6 {
                starImageView1.isHidden = false
                starImageView2.isHidden = false
                starImageView3.isHidden = false
                starImageView4.isHidden = true
                starImageView5.isHidden = true
                scoreLabel.text = "还行"
            } else if movie.score.doubleValue < 8 {
                starImageView1.isHidden = false
                starImageView2.isHidden = false
                starImageView3.isHidden = false
                starImageView4.isHidden = false
                starImageView5.isHidden = true
                scoreLabel.text = "推荐"
            } else {
                starImageView1.isHidden = false
                starImageView2.isHidden = false
                starImageView3.isHidden = false
                starImageView4.isHidden = false
                starImageView5.isHidden = false
                scoreLabel.text = "很棒"
            }
        }
    }
    
    private var coverImageView: UIImageView!
    private var titleLabel: UILabel!
    private var actorsLabel: UILabel!
    private var directorLabel: UILabel!
    private var regionLabel: UILabel!
    private var durationLabel: UILabel!
    private var releaseLabel: UILabel!
    
    private var starImageView1: UIImageView!
    private var starImageView2: UIImageView!
    private var starImageView3: UIImageView!
    private var starImageView4: UIImageView!
    private var starImageView5: UIImageView!
    private var scoreLabel: UILabel!
    private var voteCountLabel: UILabel!
        
    override func setupViews() {
        super.setupViews()
        
        coverImageView = UIImageView()
        coverImageView.layer.cornerRadius = 8
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFit
        contentView.addSubview(coverImageView)
        
        titleLabel = UILabel()
            .textColor(Color.text)
            .font(.system(15))
        contentView.addSubview(titleLabel)
        
        directorLabel = UILabel()
            .textColor(Color.text)
            .font(.system(12))
        contentView.addSubview(directorLabel)
        
        actorsLabel = UILabel()
            .textColor(Color.text)
            .font(.system(12))
        contentView.addSubview(actorsLabel)
        
        regionLabel = UILabel()
            .textColor(Color.text)
            .font(.system(12))
        contentView.addSubview(regionLabel)
        
        
        durationLabel = UILabel()
            .textColor(Color.text)
            .font(.system(12))
        contentView.addSubview(durationLabel)
        
        releaseLabel = UILabel()
            .textColor(Color.text)
            .font(.system(12))
        contentView.addSubview(releaseLabel)
        
        scoreLabel = UILabel()
            .textColor(Color.text)
            .font(.system(12))
        contentView.addSubview(scoreLabel)
        
        voteCountLabel = UILabel()
            .textColor(Color.subText)
            .font(.system(12))
        contentView.addSubview(voteCountLabel)
        
        starImageView1 = UIImageView(image: UIImage(named: "icon_star"))
        starImageView2 = UIImageView(image: UIImage(named: "icon_star"))
        starImageView3 = UIImageView(image: UIImage(named: "icon_star"))
        starImageView4 = UIImageView(image: UIImage(named: "icon_star"))
        starImageView5 = UIImageView(image: UIImage(named: "icon_star"))
        contentView.appendSubviews(with: [starImageView1, starImageView2, starImageView3, starImageView4, starImageView5])
        
        
        // layout
        coverImageView.snp.makeConstraints { make in
            make.width.equalTo(115)
            make.height.equalTo(170)
            make.left.equalTo(16)
            make.top.equalTo(16)
            make.bottom.equalTo(-16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(coverImageView.snp.right).offset(8)
            make.right.lessThanOrEqualTo(-16)
            make.top.equalTo(coverImageView).offset(2)
        }
        
        let margin: CGFloat = 10
        
        directorLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(margin)
        }
        
        actorsLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(directorLabel.snp.bottom).offset(margin)
        }
        
        releaseLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(actorsLabel.snp.bottom).offset(margin)
        }
        
        regionLabel.snp.makeConstraints { make in
            make.left.equalTo(releaseLabel.snp.right).offset(margin)
            make.centerY.equalTo(releaseLabel)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(releaseLabel.snp.bottom).offset(margin)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(durationLabel.snp.bottom).offset(margin)
        }
        
        starImageView1.snp.makeConstraints { make in
            make.left.equalTo(scoreLabel.snp.right).offset(4)
            make.width.height.equalTo(15)
            make.centerY.equalTo(scoreLabel).offset(1)
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
        
        voteCountLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(scoreLabel.snp.bottom).offset(margin)
        }
    }
    
}
