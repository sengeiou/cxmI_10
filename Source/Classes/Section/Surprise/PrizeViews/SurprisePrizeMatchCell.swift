//
//  SurprisePrizeMatchCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit



class SurprisePrizeMatchCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var stageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var matchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        matchLabel.layer.cornerRadius = 15
        matchLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}

extension SurprisePrizeMatchCell {
    public func configure(with data : PrizeListModel) {
        if let url = URL(string: data.lotteryIcon) {
            icon.kf.setImage(with: url)
        }
        title.text = data.lotteryName
        stageLabel.text = data.period
        dateLabel.text = data.date
        
        matchLabel.text = "\(data.homeTeam)  \(data.score)  \(data.visitingTeam)"
        
        switch data.lotteryId {
        case "3":  // 篮球
            matchLabel.backgroundColor = ColorFC6F1C
        case "1":  // 足球
            matchLabel.backgroundColor = Color439E0B
        default:
            matchLabel.backgroundColor = Color439E0B
        }
    }
}
