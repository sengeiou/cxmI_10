//
//  FootballLineupMemberCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballLineupMemberCell: UITableViewCell {

    static let identifier: String = "FootballLineupMemberCell"
    
    public var homeMemberInfo : FootballLineupMemberInfo! {
        didSet{
            homeLabel.text = homeMemberInfo.personName
            homeNum.text = homeMemberInfo.position
        }
    }
    public var visiMemberInfo : FootballLineupMemberInfo! {
        didSet{
            visiLabel.text = visiMemberInfo.personName
            visiNum.text = visiMemberInfo.position
        }
    }
    
    
    private var homeIcon : UIImageView!
    private var visiIcon : UIImageView!
    
    private var homeLabel: UILabel!
    private var visiLabel: UILabel!
    
    private var homeNum : UILabel!
    private var visiNum : UILabel!
    
    private var hLine : UIImageView!
    private var vLine : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    private func initSubview() {
        homeIcon = getImageView("Hometeam_2")
        visiIcon = getImageView("Visitingteam_2")
        
        homeLabel = getLabel()
        homeLabel.textAlignment = .left
        homeLabel.text = "费尔南蒂尼奥"
        
        visiLabel = getLabel()
        visiLabel.textAlignment = .left
        visiLabel.text = "拉云"
        
        homeNum = getLabel()
        homeNum.textColor = ColorFFFFFF
        homeNum.text = "3"
        
        visiNum = getLabel()
        visiNum.textColor = ColorFFFFFF
        visiNum.text = "12"
        
        hLine = getImageView("line")
        vLine = getImageView("vline")
        
        self.contentView.addSubview(hLine)
        self.contentView.addSubview(vLine)
        self.contentView.addSubview(homeIcon)
        self.contentView.addSubview(visiIcon)
        self.contentView.addSubview(homeLabel)
        self.contentView.addSubview(visiLabel)
        homeIcon.addSubview(homeNum)
        visiIcon.addSubview(visiNum)
        
        hLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.height.equalTo(1)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        vLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.width.equalTo(1)
            make.top.equalTo(hLine.snp.bottom)
            make.bottom.equalTo(0)
        }
        homeIcon.snp.makeConstraints { (make) in
            make.top.equalTo(5 * defaultScale)
            make.bottom.equalTo(-5 * defaultScale)
            make.width.equalTo(homeIcon.snp.height)
            make.left.equalTo(16 * defaultScale)
        }
        visiIcon.snp.makeConstraints { (make) in
            make.width.height.centerY.equalTo(homeIcon)
            make.left.equalTo(vLine.snp.right).offset(15 * defaultScale)
        }
        homeNum.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        visiNum.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        homeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hLine.snp.bottom)
            make.bottom.equalTo(0)
            make.left.equalTo(homeIcon.snp.right).offset(11 * defaultScale)
            make.right.equalTo(vLine.snp.left)
        }
        visiLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(homeLabel)
            make.left.equalTo(visiIcon.snp.right).offset(11 * defaultScale)
            make.right.equalTo(0)
        }
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font13
        lab.textColor = Color505050
        lab.textAlignment = .center
        return lab
    }
    
    private func getImageView(_ image: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        return imageView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
