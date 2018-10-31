//
//  BBOrderDetailTitleCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BBOrderDetailTitleCell: UITableViewCell {

    @IBOutlet weak var title : UILabel!
    // 场次
    @IBOutlet weak var changCi : UILabel!
    // 球队名称，赛事
    @IBOutlet weak var teamName : UILabel!
    // 玩法
    @IBOutlet weak var playLabel : UILabel!
    // 投注
    @IBOutlet weak var betLabel : UILabel!
    // 赛果
    @IBOutlet weak var resultLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
