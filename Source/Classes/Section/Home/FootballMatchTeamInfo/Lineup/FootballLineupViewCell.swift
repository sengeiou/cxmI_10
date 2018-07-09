//
//  FootballLineupViewCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//  偶数

import UIKit

class FootballLineupViewCell: UITableViewCell {

    static let identifier = "FootballLineupViewCell"
    
    public var lineupList : [FootballLineupMemberInfo]! {
        didSet{
            
        }
    }
    
    private var clIcon: UIImageView! // 左中
    private var crIcon: UIImageView! // 右中
    private var lIcon : UIImageView! // 左
    private var rIcon : UIImageView! // 右
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        initSubview()
    }
    
    private func initSubview() {
        clIcon = getImageView(image: "Hometeam_1")
        crIcon = getImageView(image: "Hometeam_1")
        lIcon = getImageView(image: "Hometeam_1")
        rIcon = getImageView(image: "Hometeam_1")
        
        self.contentView.addSubview(clIcon)
        self.contentView.addSubview(crIcon)
        self.contentView.addSubview(lIcon)
        self.contentView.addSubview(rIcon)
        
        clIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(clIcon.snp.height)
        }
    }
    
    private func getImageView(image: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named : image)
        imageView.alpha = 1
        return imageView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
