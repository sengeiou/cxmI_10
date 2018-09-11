//
//  TeamDetailRecordCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class TeamDetailRecordCell: UITableViewCell {

    @IBOutlet weak var bottomLine : UIImageView!
    
    @IBOutlet weak var match : UILabel!
    
    @IBOutlet weak var dateLabel : UILabel!
    
    @IBOutlet weak var homeLabel : UILabel!
    @IBOutlet weak var visiLabel : UILabel!
    
    @IBOutlet weak var scoreLabel : UILabel!
    
    @IBOutlet weak var winLabel : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        match.textColor = Color9F9F9F
        dateLabel.textColor = Color9F9F9F
        scoreLabel.textColor = Color9F9F9F
        winLabel.textColor = Color9F9F9F
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TeamDetailRecordCell {
    public func configure(with data : TeamRecordInfo, homeMatch : String, style : TeamCellStyle) {
        bottomLine.image = UIImage(named: "line")
        switch style {
        case .title:
            match.text = "赛事"
            dateLabel.text = "日期"
            scoreLabel.text = "比分"
            winLabel.text = "胜负"
            homeLabel.text = ""
            visiLabel.text = ""
        case .data :
            
            match.text = data.match
            dateLabel.text = data.date
            scoreLabel.text = data.score
            homeLabel.text = data.hTeam
            visiLabel.text = data.vTeam
            winLabel.text = data.status
            
            var color = Color9F9F9F
            
            switch data.status {
            case "胜":
                color = ColorEA5504
            case "平":
                color = Color65AADD
            case "负":
                color = Color44AE35
            default : break
            }
            
            var homeColor = Color9F9F9F
            var visiColor = Color9F9F9F
            
            if data.hTeam == homeMatch {
                homeColor = color
            }
            if data.vTeam == homeMatch {
                visiColor = color
            }
            
            scoreLabel.textColor = color
            
            homeLabel.textColor = homeColor
            visiLabel.textColor = visiColor
            winLabel.textColor = color
        }
        
    }
}
