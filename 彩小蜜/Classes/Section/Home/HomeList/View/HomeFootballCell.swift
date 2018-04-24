//
//  HomeFootballCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class HomeFootballCell: UICollectionViewCell {
    
    public var playModel: HomePlayModel! {
        didSet{
            if let url = URL(string: playModel.playClassifyImg) {
                icon.kf.setImage(with: url)
            }
            
            title.text = playModel.playClassifyName
        }
    }
    
    private var icon : UIImageView!
    private var title : UILabel!
    private var activityIcon : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5)
            make.left.equalTo(self.contentView).offset(10 * defaultScale)
            make.right.equalTo(self.contentView).offset(-10 * defaultScale)
            make.height.equalTo(icon.snp.width)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(5)
            make.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-5)
        }
//        activityIcon.snp.makeConstraints { (make) in
//            make.top.equalTo(icon)
//            make.left.equalTo(icon.snp.right).offset(-5)
//            make.height.equalTo(20)
//            make.width.equalTo(20)
//        }
    }
    
    private func initSubview() {
        icon = UIImageView()
        icon.image = UIImage(named: "足球")
        
        title = UILabel()
        title.font = Font11
        title.textColor = ColorA0A0A0
        title.text = "单关固定"
        title.textAlignment = .center
        
        activityIcon = UIImageView()
        activityIcon.image = UIImage(named: "足球")
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        //self.contentView.addSubview(activityIcon)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
