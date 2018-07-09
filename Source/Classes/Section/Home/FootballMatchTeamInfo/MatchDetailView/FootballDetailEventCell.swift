//
//  FootballDetailEventCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let timeLabelWidth : CGFloat = 30

class FootballDetailEventCell: UITableViewCell {

    static let identifier : String = "FootballDetailEventCellId"
    
    public var eventInfo : FootballLiveEventInfo! {
        didSet{
            
        }
    }
    
    public var hiddenStart = true {
        didSet{
            self.startIcon.isHidden = hiddenStart
            self.timeLabel.isHidden = !hiddenStart
        }
    }
    public var hiddenTop = false {
        didSet{
            self.topLine.isHidden = hiddenTop
        }
    }
    public var hiddenBot = false {
        didSet{
            self.botLine.isHidden = hiddenBot
        }
    }
    public var score : String! {
        didSet{
            self.homeScoreLabel.text = score
        }
    }
    
    private var timeLabel: UILabel!
    
    private var homeTeamMember : UILabel!
    private var visiTeamMember : UILabel!
    
    private var startIcon : UIImageView!
    
    private var homeScoreLabel: UILabel!
    private var visiScoreLabel: UILabel!
    
    private var homeGoalIcon: UIImageView!
    private var visiGoalIcon: UIImageView!
    
    private var homeEventIcon: UIImageView!
    private var visiEventIcon: UIImageView!
    
    private var topLine: UIView!
    private var botLine: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initSubview()
    }
    
    private func initSubview() {
        
        topLine = UIView()
        topLine.backgroundColor = ColorF6AD41
        
        botLine = UIView()
        botLine.backgroundColor = ColorF6AD41
        
        startIcon = UIImageView()
        startIcon.image = UIImage(named: "star")
        
        timeLabel = initLabel()
        timeLabel.layer.cornerRadius = timeLabelWidth / 2
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.borderWidth = 2
        timeLabel.layer.borderColor = ColorF6AD41.cgColor
        timeLabel.text = "40′"
        
        homeTeamMember = initLabel()
        homeTeamMember.font = Font13
        homeTeamMember.textAlignment = .left
        homeTeamMember.text = "内马尔"
        
        homeScoreLabel = initLabel()
        homeScoreLabel.textColor = ColorF6AD41
        
        homeScoreLabel.sizeToFit()
        
        homeGoalIcon = UIImageView()
        homeGoalIcon.image = UIImage(named: "Penalty")
        
        homeEventIcon = UIImageView()
        homeEventIcon.image = UIImage(named: "Goals_2")
        
        visiTeamMember = initLabel()
        visiTeamMember.font = Font13
        visiTeamMember.textAlignment = .right
        visiTeamMember.text = "伊格纳舍维奇"
        
        visiScoreLabel = initLabel()
        visiScoreLabel.textColor = ColorF6AD41
        visiScoreLabel.sizeToFit()
        
        visiGoalIcon = UIImageView()
        visiGoalIcon.image = UIImage(named: "Penalty")
        
        visiEventIcon = UIImageView()
        visiEventIcon.image = UIImage(named: "Play_2")
        
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(botLine)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(startIcon)
        self.contentView.addSubview(homeTeamMember)
        self.contentView.addSubview(homeScoreLabel)
        self.contentView.addSubview(homeGoalIcon)
        self.contentView.addSubview(homeEventIcon)
        self.contentView.addSubview(visiTeamMember)
        self.contentView.addSubview(visiScoreLabel)
        self.contentView.addSubview(visiGoalIcon)
        self.contentView.addSubview(visiEventIcon)
        
        startIcon.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(timeLabel)
        }
        
        topLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.bottom.equalTo(timeLabel.snp.top)
            make.width.equalTo(1)
        }
        botLine.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom)
            make.bottom.equalTo(0)
            make.centerX.width.equalTo(topLine)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.height.width.equalTo(timeLabelWidth)
            make.center.equalTo(self.contentView.snp.center)
        }
        
        homeTeamMember.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(25 * defaultScale)
            make.right.equalTo(homeScoreLabel.snp.left)
        }
        homeScoreLabel.snp.makeConstraints { (make) in
           // make.width.equalTo(60 * defaultScale)
            make.top.bottom.equalTo(homeTeamMember)
            make.right.equalTo(homeGoalIcon.snp.left).offset(-8 * defaultScale)
        }
        homeGoalIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(14 * defaultScale)
            make.centerY.equalTo(homeTeamMember.snp.centerY)
            make.right.equalTo(homeEventIcon.snp.left).offset(-5 * defaultScale)
        }
        homeEventIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(18 * defaultScale)
            make.centerY.equalTo(homeGoalIcon)
            make.right.equalTo(timeLabel.snp.left).offset(-10 * defaultScale)
        }
        
        visiTeamMember.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(-25 * defaultScale)
            make.left.equalTo(visiScoreLabel.snp.right)
        }
        visiScoreLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(visiTeamMember)
            make.left.equalTo(visiGoalIcon.snp.right).offset(8 * defaultScale)
        }
        visiGoalIcon.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(homeGoalIcon)
            make.left.equalTo(visiEventIcon.snp.right).offset(5 * defaultScale)
        }
        visiEventIcon.snp.makeConstraints { (make) in
            make.width.height.centerY.equalTo(homeEventIcon)
            make.left.equalTo(timeLabel.snp.right).offset(10 * defaultScale)
        }
        
    }
    
    private func initLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.textColor = Color505050
        lab.textAlignment = .center
        return lab
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
