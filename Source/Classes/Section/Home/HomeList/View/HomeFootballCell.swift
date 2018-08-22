//
//  HomeFootballCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class HomeFootballCell: UICollectionViewCell, RouterMatcher {
    
    public var playModel: HomePlayModel! {
        didSet{
            guard playModel != nil else { return }
            if let url = URL(string: playModel.lotteryImg) {
                icon.kf.setImage(with: url)
            }
            
            title.text = playModel.lotteryName
            subTitle.text = playModel.subTitle
            
            let type = matcherHttp(urlStr: playModel.redirectUrl)
            
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
    
    private var icon : UIImageView!
    private var title : UILabel!
    private var subTitle: UILabel!
    private var activityIcon : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
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
    
    private func initSubview() {
        icon = UIImageView()
        icon.image = UIImage(named: "足球")
        
        title = UILabel()
        title.font = Font14
        title.textColor = Color505050
        title.text = "单关固定"
        title.textAlignment = .center
        
        subTitle = UILabel()
        subTitle.font = Font12
        subTitle.textColor = Color787878
        subTitle.text = "单关固定"
        subTitle.textAlignment = .center
        
        activityIcon = UIImageView()
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        self.contentView.addSubview(subTitle)
        self.contentView.addSubview(activityIcon)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
