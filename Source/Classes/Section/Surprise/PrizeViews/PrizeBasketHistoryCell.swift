//
//  PrizeBasketHistoryCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class PrizeBasketHistoryCell: UITableViewCell {

    @IBOutlet weak var dateLabel : UILabel!  //时间
    @IBOutlet weak var leagueLabel : UILabel!//联赛
    @IBOutlet weak var homeLabel : UILabel!  //主队
    @IBOutlet weak var visiLabel : UILabel!  //客队
    @IBOutlet weak var totalScore: UILabel!  //全场比分
    
    @IBOutlet weak var sfLabel  : UILabel!   //胜负
    @IBOutlet weak var rangLabel : UILabel!  //让分胜负
    @IBOutlet weak var sfcLabel: UILabel!    //胜分差
    @IBOutlet weak var dxfLabel: UILabel!  //大小分
  
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension PrizeBasketHistoryCell {
    public func configure(with data : MatchHisInfo) {
        leagueLabel.text = data.cupName
        dateLabel.text = data.changci + " " + data.matchTime
        homeLabel.text = data.homeTeamAbbr
        visiLabel.text = data.visitTeamAbbr
        totalScore.text = data.whole
        
        sfLabel.text = data.mnl
        rangLabel.text = data.hdc
        sfcLabel.text = data.wnm
        dxfLabel.text = data.hilo
    }
}
