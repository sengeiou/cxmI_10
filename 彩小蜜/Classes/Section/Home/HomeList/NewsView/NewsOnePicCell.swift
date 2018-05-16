//
//  NewsOnePicCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

let PicHeight : CGFloat = 80 * defaultScale
fileprivate let PicWidth : CGFloat = (screenWidth - 12 * 2 - 5 * 2) / 3

class NewsOnePicCell: UITableViewCell {

    // MARK: - 属性 public
    public var newsInfo : NewsInfoModel!{
        didSet{
            guard newsInfo != nil else { return }
            bottomView.newsInfo = newsInfo
            
            titleLb.text = newsInfo.title
            if newsInfo.listStyle == "4" {
                guard newsInfo.articleThumb.count == 1 else { return }
                guard let url = URL(string: newsInfo.articleThumb[0]) else { return }
                icon.kf.setImage(with: url)
                videoIcon.isHidden = false
            }else {
                guard newsInfo.articleThumb.count == 1 else { return }
                guard let url = URL(string: newsInfo.articleThumb[0]) else { return }
                icon.kf.setImage(with: url)
                //uploadFiles/uploadImgs/20180509/5bd9485354f14941a976ec6f39fd9ef5.png
                videoIcon.isHidden = true
            }
        }
    }
    
    // MARK: - 属性 private
    private var titleLb : UILabel!
    public var icon : UIImageView!
    private var bottomView: NewsBottomView!
    private var videoIcon : UIImageView!
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
        
        icon = UIImageView()
        icon.layer.borderWidth = 0.5
        icon.layer.borderColor = ColorEAEAEA.cgColor
        icon.image = UIImage(named: "Racecolorfootball")
        
        videoIcon = UIImageView()
        videoIcon.image = UIImage(named: "bofang")
        
        titleLb = getLabel()
        
        bottomView = NewsBottomView()
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorC8C8C8
        
        self.contentView.addSubview(bottomLine)
        self.contentView.addSubview(icon)
        self.contentView.addSubview(titleLb)
        self.contentView.addSubview(bottomView)
        icon.addSubview(videoIcon)
        
        icon.snp.makeConstraints { (make) in
            //make.top.equalTo(14 * defaultScale)
            
            //make.bottom.equalTo(-14 * defaultScale)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(-12 * defaultScale)
            make.width.equalTo(PicWidth)
            make.height.equalTo(PicHeight)
        }
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(icon)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(icon.snp.left).offset(-21 * defaultScale)
           // make.height.equalTo(40 * defaultScale)
        }
        bottomView.snp.makeConstraints { (make) in
           // make.bottom.equalTo(-10 * defaultScale)
            make.left.equalTo(titleLb)
            make.right.equalTo(titleLb)
            make.bottom.equalTo(bottomLine.snp.top).offset(-12 * defaultScale)
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(0.5)
        }
        videoIcon.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font15
        lab.textColor = Color505050
        lab.textAlignment = .left
        lab.numberOfLines = 2
        lab.contentMode = .topLeft
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
