//
//  PrizeMatchHistoryCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class PrizeFootHistoryCell: UITableViewCell {

    @IBOutlet weak var dateLabel : UILabel!  //时间
    @IBOutlet weak var leagueLabel : UILabel!//联赛
    @IBOutlet weak var homeLabel : UILabel!  //主队
    @IBOutlet weak var visiLabel : UILabel!  //客队
    @IBOutlet weak var totalScore: UILabel!  //全场比分
    @IBOutlet weak var halfScore : UILabel!  //半场比分
    @IBOutlet weak var spfLabel  : UILabel!  //胜平负
    @IBOutlet weak var rangLabel : UILabel!  //让球
    @IBOutlet weak var scoreLabel: UILabel!  //比分
    @IBOutlet weak var totalLabel: UILabel!  //总进球
    @IBOutlet weak var banLabel  : UILabel!  //半全场
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
extension PrizeFootHistoryCell {
    public func configure(with data : MatchHisInfo) {
        leagueLabel.text = data.cupName
        dateLabel.text = data.changciId + " "  + data.matchTime
        homeLabel.text = data.homeTeamAbbr
        visiLabel.text = data.visitTeamAbbr
        halfScore.text = "半场\(data.half)"
        totalLabel.text = data.whole
        
        spfLabel.text = data.had
        rangLabel.text = data.hhad
        scoreLabel.text = data.crs
        totalLabel.text = data.ttg
        banLabel.text = data.hafu
    }
}

