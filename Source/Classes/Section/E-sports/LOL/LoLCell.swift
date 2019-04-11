//
//  ESportsLoLCell.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/26.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

class LoLCell: UITableViewCell {

    /// 赛季
    @IBOutlet weak var season : UILabel!
    /// 比赛时间
    @IBOutlet weak var date : UILabel!
    /// 主队
    @IBOutlet weak var homeTeam : UILabel!
    /// 客队
    @IBOutlet weak var visiTeam : UILabel!
    /// 主队Logo
    @IBOutlet weak var homeIcon : UIImageView!
    /// 客队Logo
    @IBOutlet weak var visiIcon : UIImageView!
    /// 投注信息
    @IBOutlet weak var betDetail : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }
}

extension LoLCell {
    private func initSubview() {
        betDetail.layer.cornerRadius = 5
        betDetail.layer.borderWidth = 1
        betDetail.layer.borderColor = ColorD31E14.cgColor
        betDetail.textColor = ColorD31E14
    }
}
