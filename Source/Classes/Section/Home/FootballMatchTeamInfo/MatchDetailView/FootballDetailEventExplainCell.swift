//
//  FootballDetailEventExplainCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballDetailEventExplainCell: UITableViewCell {

    static let identifier : String = "FootballDetailEventExplainCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initSubview()
    }
    private func initSubview() {
        let goalIcon = getImageView("Goals_1")
        let goalLab = getLabel("入球")
        
        let wulongIcon = getImageView("Owngoals_1")
        let wulongLab = getLabel("乌龙")
        
        let huangIcon = getImageView("Yellowcard_1")
        let huangLab = getLabel("黄牌")
        
        let hongIcon = getImageView("redcard_1")
        let hongLab = getLabel("红牌")
        
        let upIcon = getImageView("Play_1")
        let upLab = getLabel("换上")
        
        let downIcon = getImageView("final_1")
        let downLab = getLabel("换下")
        
        self.contentView.addSubview(goalIcon)
        self.contentView.addSubview(goalLab)
        self.contentView.addSubview(wulongIcon)
        self.contentView.addSubview(wulongLab)
        self.contentView.addSubview(huangIcon)
        self.contentView.addSubview(huangLab)
        self.contentView.addSubview(hongIcon)
        self.contentView.addSubview(hongLab)
        self.contentView.addSubview(upIcon)
        self.contentView.addSubview(upLab)
        self.contentView.addSubview(downIcon)
        self.contentView.addSubview(downLab)
        
        goalIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(16)
            make.left.equalTo(16 * defaultScale)
            make.centerY.equalTo(self.contentView)
        }
        goalLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(goalIcon)
            make.left.equalTo(goalIcon.snp.right).offset(4)
            make.width.equalTo(downLab)
        }
        wulongIcon.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(goalIcon)
            make.left.equalTo(goalLab.snp.right).offset(4)
        }
        wulongLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(goalIcon)
            make.left.equalTo(wulongIcon.snp.right).offset(4)
            make.width.equalTo(downLab)
        }
        huangIcon.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(goalIcon)
            make.left.equalTo(wulongLab.snp.right).offset(4)
        }
        huangLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(goalIcon)
            make.left.equalTo(huangIcon.snp.right).offset(4)
            make.width.equalTo(downLab)
        }
        hongIcon.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(goalIcon)
            make.left.equalTo(huangLab.snp.right).offset(4)
        }
        hongLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(goalIcon)
            make.left.equalTo(hongIcon.snp.right).offset(4)
            make.width.equalTo(downLab)
        }
        upIcon.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(goalIcon)
            make.left.equalTo(hongLab.snp.right).offset(4)
        }
        upLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(goalIcon)
            make.left.equalTo(upIcon.snp.right).offset(4)
            make.width.equalTo(downLab)
        }
        downIcon.snp.makeConstraints { (make) in
            make.centerY.height.width.equalTo(goalIcon)
            make.left.equalTo(upLab.snp.right).offset(4)
        }
        downLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(goalIcon)
            make.left.equalTo(downIcon.snp.right).offset(4)
            make.right.equalTo(-5)
        }
        
    }

    private func getImageView(_ image: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        return imageView
    }
    
    private func getLabel(_ text: String) -> UILabel {
        let lab = UILabel()
        lab.text = text
        lab.font = Font13
        lab.textColor = Color505050
        lab.textAlignment = .left
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
