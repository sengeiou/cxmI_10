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
        
        let goalsWuIcon = getImageView("Invalidgoal")
        let goalsWuLab = getLabel("入球无效")
        
        let psmIcon = getImageView("IostPenalty")
        let psmLab = getLabel("点球未进")
        
        let y2cIcon = getImageView("Redden")
        let y2cLab = getLabel("两黄变红")
        
        let asIcon = getImageView("Assist")
        let asLab = getLabel("助攻")
        
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
        
        self.contentView.addSubview(goalsWuIcon)
        self.contentView.addSubview(goalsWuLab)
        self.contentView.addSubview(psmIcon)
        self.contentView.addSubview(psmLab)
        self.contentView.addSubview(y2cIcon)
        self.contentView.addSubview(y2cLab)
        self.contentView.addSubview(asIcon)
        self.contentView.addSubview(asLab)
        
        goalIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(16)
            make.left.equalTo(16 * defaultScale)
            make.top.equalTo(30)
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
        goalsWuIcon.snp.makeConstraints { (make) in
            make.left.height.width.equalTo(goalIcon)
            make.bottom.equalTo(-30)
        }
        goalsWuLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(goalsWuIcon)
            make.left.equalTo(goalsWuIcon.snp.right).offset(4)
            make.width.equalTo(asLab)
        }
        psmIcon.snp.makeConstraints { (make) in
            make.height.width.bottom.equalTo(goalsWuIcon)
            make.left.equalTo(goalsWuLab.snp.right).offset(4)
        }
        psmLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(goalsWuIcon)
            make.left.equalTo(psmIcon.snp.right).offset(4)
            make.width.equalTo(asLab)
        }
        y2cIcon.snp.makeConstraints { (make) in
            make.height.width.bottom.equalTo(goalsWuIcon)
            make.left.equalTo(psmLab.snp.right).offset(4)
        }
        y2cLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(goalsWuIcon)
            make.left.equalTo(y2cIcon.snp.right).offset(4)
            make.width.equalTo(asLab)
        }
        asIcon.snp.makeConstraints { (make) in
            make.height.width.bottom.equalTo(goalsWuIcon)
            make.left.equalTo(y2cLab.snp.right).offset(4)
        }
        asLab.snp.makeConstraints { (make) in
            make.centerY.height.equalTo(goalsWuIcon)
            make.left.equalTo(asIcon.snp.right).offset(4)
            make.right.equalTo(downLab)
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
