//
//  LeagueDetailCourseCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class LeagueDetailCourseCell: UITableViewCell {

    @IBOutlet weak var topLine : UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    
    @IBOutlet weak var dateLabel : UILabel!
    
    @IBOutlet weak var homeLabel : UILabel!
    
    @IBOutlet weak var visiLabel : UILabel!
    
    @IBOutlet weak var vsLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension LeagueDetailCourseCell {
    public func configure(with data : LeagueMatchInfo, style : LeagueShooterStyle) {
        switch style {
        case .title:
            dateLabel.text = "比赛时间"
            homeLabel.text = "主队"
            visiLabel.text = "客队"
            vsLabel.text = ""
            dateLabel.font = Font12
            dateLabel.backgroundColor = ColorF4F4F4
            homeLabel.backgroundColor = ColorF4F4F4
            visiLabel.backgroundColor = ColorF4F4F4
            vsLabel.backgroundColor = ColorF4F4F4
        case .defau:
            dateLabel.text = data.matchTime
            homeLabel.text = data.homeTeamAbbr
            visiLabel.text = data.visitorTeamAbbr
            vsLabel.text = "vs"
            dateLabel.font = Font9
            
            dateLabel.backgroundColor = ColorFFFFFF
            homeLabel.backgroundColor = ColorFFFFFF
            visiLabel.backgroundColor = ColorFFFFFF
            vsLabel.backgroundColor = ColorFFFFFF
            
        }
    }
}

