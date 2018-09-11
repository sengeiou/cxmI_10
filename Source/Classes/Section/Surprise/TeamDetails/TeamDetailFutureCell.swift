//
//  TeamDetailFutureCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class TeamDetailFutureCell: UITableViewCell {
    @IBOutlet weak var topline : UIView!
    @IBOutlet weak var bottomLine : UIView!
    @IBOutlet weak var leftLine : UIView!
    @IBOutlet weak var rightLine : UIView!
    
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var leagueName : UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var visiLabel: UILabel!
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

extension TeamDetailFutureCell {
    public func configure(with data : TeamFutureInfo, style : TeamCellStyle) {
        switch style {
        case .title:
            dateLabel.text = "比赛时间"
            leagueName.text = "赛事"
            homeLabel.text = "主队"
            visiLabel.text = "客队"
            vsLabel.text = ""
            
            dateLabel.backgroundColor = ColorF4F4F4
            leagueName.backgroundColor = ColorF4F4F4
            homeLabel.backgroundColor = ColorF4F4F4
            visiLabel.backgroundColor = ColorF4F4F4
            vsLabel.backgroundColor = ColorF4F4F4
            
        case .data:
            dateLabel.text = data.date
            leagueName.text = data.matchName
            homeLabel.text = data.hTeam
            visiLabel.text = data.vTeam
            vsLabel.text = "vs"
            
            dateLabel.backgroundColor = ColorFFFFFF
            leagueName.backgroundColor = ColorFFFFFF
            homeLabel.backgroundColor = ColorFFFFFF
            visiLabel.backgroundColor = ColorFFFFFF
            vsLabel.backgroundColor = ColorFFFFFF
        }
        
    }
}
