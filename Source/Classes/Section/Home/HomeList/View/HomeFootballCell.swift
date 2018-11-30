//
//  HomeFootballCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class HomeFootballCell: UICollectionViewCell, RouterMatcher {
    
    public static let identifier : String = "HomeFootballCellId"

    private var icon : UIImageView!
    private var title : UILabel!
    private var subTitle: UILabel!
    private var activityIcon : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeFootballCell {
    // 发现
    public func configure(with data : HomeFindModel) {
        
        if let url = URL(string: data.classImg) {
            icon.kf.setImage(with: url)
        }
        
        title.text = data.className
    }
    // 玩法
    public func configure(with data : HomePlayModel) {
        if let url = URL(string: data.lotteryImg) {
            icon.kf.setImage(with: url)
        }
        
        title.text = data.lotteryName
        subTitle.text = data.subTitle
        
        let type = matcherHttp(urlStr: data.redirectUrl)
        
        switch type.0 {
        case .竞彩足球:
            subTitle.textColor = ColorE85504
        case .大乐透:
            subTitle.textColor = ColorE85504
        default:
            subTitle.textColor = Color787878
        }
    }
}

// MARK: - 初始化
extension HomeFootballCell {
    private func initSubview() {
        icon = UIImageView()
        icon.image = UIImage(named: "足球")
        
        
        title = UILabel()
        title.font = Font14
        title.textColor = Color505050
        title.textAlignment = .center
        
        subTitle = UILabel()
        subTitle.font = Font12
        subTitle.textColor = Color787878
        subTitle.textAlignment = .center
        
        activityIcon = UIImageView()
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        self.contentView.addSubview(subTitle)
        self.contentView.addSubview(activityIcon)
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5)
            make.left.equalTo(self.contentView).offset(15 * defaultScale)
            make.right.equalTo(self.contentView).offset(-15 * defaultScale)
            make.height.equalTo(icon.snp.width)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(5)
            make.left.right.equalTo(self.contentView)
            make.height.equalTo(subTitle)
        }
        subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.left.right.equalTo(title)
            make.bottom.equalTo(self.contentView).offset(-5)
        }
        activityIcon.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(icon.snp.right).offset(-5)
            make.width.height.equalTo(32 * defaultScale)
        }
    }
}
