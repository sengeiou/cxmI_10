//
//  NewsThreePicCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class NewsThreePicCell: UITableViewCell {

    // MARK: - 属性 public
    public var newsInfo : NewsInfoModel!{
        didSet{
            guard newsInfo != nil else { return }
            bottomView.newsInfo = newsInfo
            
            titleLb.text = newsInfo.title
            
            guard newsInfo.articleThumb.count >= 3 else { return }
            guard let url0 = URL(string: newsInfo.articleThumb[0]) else { return }
            guard let url1 = URL(string: newsInfo.articleThumb[1]) else { return }
            guard let url2 = URL(string: newsInfo.articleThumb[2]) else { return }
            
            picOne.kf.setImage(with: url0)
            picTwo.kf.setImage(with: url1)
            picThree.kf.setImage(with: url2)
        }
    }
    
    // MARK: - 属性 private
    private var titleLb : UILabel!
    private var bottomView: NewsBottomView!
    private var picOne : UIImageView!
    private var picTwo : UIImageView!
    private var picThree: UIImageView!
    private var bottomLine : UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initSubview() {
        
        self.selectionStyle = .none
        
        titleLb = getLabel()
        
        bottomView = NewsBottomView()
        
        picOne = UIImageView()
        
        //picOne.image = UIImage(named: "Racecolorfootball")
        picTwo = UIImageView()
        //picTwo.image = UIImage(named: "Racecolorfootball")
        picThree = UIImageView()
        //picThree.image = UIImage(named: "Racecolorfootball")
        
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorC8C8C8
        
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(titleLb)
        self.contentView.addSubview(bottomView)
        self.contentView.addSubview(picOne)
        self.contentView.addSubview(picTwo)
        self.contentView.addSubview(picThree)
        
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(10 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-leftSpacing)
            make.height.equalTo(15 * defaultScale)
        }
        
        bottomView.snp.makeConstraints { (make) in
            //make.bottom.equalTo(-12 * defaultScale)
            make.left.equalTo(titleLb)
            make.right.equalTo(-12 * defaultScale)
            make.bottom.equalTo(bottomLine.snp.top).offset(-12 * defaultScale)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(0.5)
        }
        picOne.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(10 * defaultScale)
            make.bottom.equalTo(bottomView.snp.top).offset(-10 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.width.equalTo(picThree)
        }
        picTwo.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(picThree)
            make.left.equalTo(picOne.snp.right).offset(5)
        }
        picThree.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(picOne)
            make.left.equalTo(picTwo.snp.right).offset(5)
            make.right.equalTo(-leftSpacing)
        }
        
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font15
        lab.textColor = Color505050
        lab.textAlignment = .left
        lab.numberOfLines = 1
        return lab
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
