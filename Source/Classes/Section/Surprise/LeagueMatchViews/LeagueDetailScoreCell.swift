//
//  LeagueDetailScoreCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class LeagueDetailScoreCell: UITableViewCell {

    @IBOutlet weak var topLine : UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    
    @IBOutlet weak var rankingLabel : UILabel! // 排名
    @IBOutlet weak var teamLabel : UILabel!    // 球队名称
    @IBOutlet weak var matchCount : UILabel!   //比赛次数
    @IBOutlet weak var winLabel : UILabel!     // 胜
    @IBOutlet weak var flatLabel: UILabel!     // 平
    @IBOutlet weak var negativeLabel: UILabel! // 负
    @IBOutlet weak var goalLabel: UILabel!     // 进球
    @IBOutlet weak var loseLabel: UILabel!     // 失球
    @IBOutlet weak var integralLabel: UILabel! // 积分
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

extension LeagueDetailScoreCell {
    public func configure(with data : LeagueTeamScoreInfo, style : TeamCellStyle) {
        
        switch style {
        case .title:
            rankingLabel.text = "排名"
            teamLabel.text = "球队"
            matchCount.text = "赛"
            winLabel.text = "胜"
            flatLabel.text = "平"
            negativeLabel.text = "负"
            goalLabel.text = "进"
            loseLabel.text = "失"
            integralLabel.text = "积分"
            
            rankingLabel.backgroundColor = ColorF4F4F4
            teamLabel.backgroundColor = ColorF4F4F4
            matchCount.backgroundColor = ColorF4F4F4
            winLabel.backgroundColor = ColorF4F4F4
            flatLabel.backgroundColor = ColorF4F4F4
            negativeLabel.backgroundColor = ColorF4F4F4
            goalLabel.backgroundColor = ColorF4F4F4
            loseLabel.backgroundColor = ColorF4F4F4
            integralLabel.backgroundColor = ColorF4F4F4
        case .data :
            rankingLabel.text = data.teamOrder
            teamLabel.text = data.teamName
            matchCount.text = data.matchNum
            winLabel.text = data.matchH
            flatLabel.text = data.matchD
            negativeLabel.text = data.matchL
            goalLabel.text = data.ballIn
            loseLabel.text = data.ballLose
            integralLabel.text = data.score
            
            rankingLabel.backgroundColor = ColorFFFFFF
            teamLabel.backgroundColor = ColorFFFFFF
            matchCount.backgroundColor = ColorFFFFFF
            winLabel.backgroundColor = ColorFFFFFF
            flatLabel.backgroundColor = ColorFFFFFF
            negativeLabel.backgroundColor = ColorFFFFFF
            goalLabel.backgroundColor = ColorFFFFFF
            loseLabel.backgroundColor = ColorFFFFFF
            integralLabel.backgroundColor = ColorFFFFFF
        }
    }
}
