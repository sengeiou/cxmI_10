//
//  BasketballHunheCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BasketballHunheCell: UITableViewCell {

    @IBOutlet weak var topLineOne : UIView!
    @IBOutlet weak var topLineTwo : UIView!
    @IBOutlet weak var topLineThree: UIView!
    @IBOutlet weak var topLineFour : UIView!
    
    @IBOutlet weak var leftLineOne : UIView!
    @IBOutlet weak var leftLineTwo : UIView!
    @IBOutlet weak var leftLineThree: UIView!
    
    @IBOutlet weak var rightLineOne: UIView!
    @IBOutlet weak var rightLineTwo: UIView!
    @IBOutlet weak var rightLineThree: UIView!
    
    // 客队
    @IBOutlet weak var visiTeam : UILabel!
    // vs
    @IBOutlet weak var vsTeam : UILabel!
    // 主队
    @IBOutlet weak var homeTeam : UILabel!
    
    // 联赛名
    @IBOutlet weak var leagueLabel : UILabel!
    // 日期
    @IBOutlet weak var dateLabel : UILabel!
    // 截止时间
    @IBOutlet weak var timeLabel : UILabel!
    
    // 胜负
    @IBOutlet weak var sfTitle : UILabel!
    @IBOutlet weak var sfVisiTeam : UIButton!
    @IBOutlet weak var sfHomeTeam : UIButton!
    // 让分
    @IBOutlet weak var rfTitle: UILabel!
    @IBOutlet weak var rfVisiTeam : UIButton!
    @IBOutlet weak var rfHomeTeam : UIButton!
    // 大小分
    @IBOutlet weak var dsfTitle : UILabel!
    @IBOutlet weak var dsfVisiTeam : UIButton!
    @IBOutlet weak var dsfHomeTeam : UIButton!
    
    // 更多玩法
    @IBOutlet weak var moreButton : UIButton!
    
    @IBAction func moreButtonClick(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
