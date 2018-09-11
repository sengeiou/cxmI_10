//
//  DigitalHisDetailLottoCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DigitalHisDetailLottoCell: UITableViewCell {

    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var leftLine: UIView!
    
    @IBOutlet weak var rightLine: UIView!
    
    @IBOutlet weak var prizeLabel : UILabel!
    @IBOutlet weak var winningBetNum : UILabel!
    @IBOutlet weak var amountLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }

    private func initSubview() {
        prizeLabel.textColor = Color505050
        winningBetNum.textColor = Color505050
        amountLabel.textColor = Color505050
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}

extension DigitalHisDetailLottoCell {
    public func configure(with data : PrizeRewardDetailModel, isTitle : Bool) {
        switch isTitle {
        case true:
            prizeLabel.text = "奖项"
            winningBetNum.text = "中奖注数(注)"
            amountLabel.text = "每注金额(元)"
            amountLabel.textColor = Color505050
        case false:
            prizeLabel.text = data.rewardLevelName
            winningBetNum.text = data.rewardNum
            amountLabel.text = data.rewardPrice
            amountLabel.textColor = ColorE95504
        }
    }
}
