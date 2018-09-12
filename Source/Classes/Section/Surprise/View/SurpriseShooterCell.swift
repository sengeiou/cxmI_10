//
//  SurpriseShooterCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class SurpriseShooterCell: UITableViewCell {
    
    @IBOutlet weak var topLine: UIView!
    
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initSubview()
    }

    private func initSubview() {
        self.numLabel.text = "排名"
        self.memberLabel.text = "球员"
        self.teamLabel.text = "球队"
        self.totalLabel.text = "总进球数"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension SurpriseShooterCell {
    public func configure(with info : LeagueShooterInfo) {
        self.numLabel.text = info.sort
        self.memberLabel.text = info.playerName
        self.teamLabel.text = info.playerTeam
        self.totalLabel.text = info.inNum
    }
}
