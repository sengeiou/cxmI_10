//
//  LeagueDetailShooterCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum LeagueShooterStyle {
    case title
    case defau
}

class LeagueDetailShooterCell: UITableViewCell {

    @IBOutlet weak var topLine : UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    
    @IBOutlet weak var rankLable: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension LeagueDetailShooterCell {
    public func configure(with data : LeagueShooterInfo, style : LeagueShooterStyle) {
        
        switch style {
        case .title:
            rankLable.text = "排名"
            memberLabel.text = "球员"
            matchLabel.text = "球队"
            goalLabel.text = "进球（点)"
            
            rankLable.backgroundColor = ColorF4F4F4
            memberLabel.backgroundColor = ColorF4F4F4
            matchLabel.backgroundColor = ColorF4F4F4
            goalLabel.backgroundColor = ColorF4F4F4
            
        case .defau:
            
            rankLable.text = data.sort
            memberLabel.text = data.playerName
            matchLabel.text = data.playerTeam
            goalLabel.text = data.inNum
            
            rankLable.backgroundColor = ColorFFFFFF
            memberLabel.backgroundColor = ColorFFFFFF
            matchLabel.backgroundColor = ColorFFFFFF
            goalLabel.backgroundColor = ColorFFFFFF
        }
        
        
    }
}
