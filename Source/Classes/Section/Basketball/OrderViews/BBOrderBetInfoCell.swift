//
//  BBOrderBetInfoCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BBOrderBetInfoCell: UITableViewCell {

    @IBOutlet weak var guoguan : UILabel!
    @IBOutlet weak var betLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BBOrderBetInfoCell {
    public func configure(with data : OrderInfoModel) {
        
        let guoguanAtt = NSMutableAttributedString(string: "过关方式: ",
                                                   attributes: [NSAttributedString.Key.foregroundColor : ColorA0A0A0])
        let guoguan = NSAttributedString(string: "\(data.passType)",
            attributes: [NSAttributedString.Key.foregroundColor: Color505050])
        
        guoguanAtt.append(guoguan)
        
        self.guoguan.attributedText = guoguanAtt
        
        let betAtt = NSMutableAttributedString(string: "投注倍数: ",
                                               attributes: [NSAttributedString.Key.foregroundColor : ColorA0A0A0])
        
        let bet = NSAttributedString(string: "\(data.betNum)注\(data.cathectic)倍",
            attributes: [NSAttributedString.Key.foregroundColor: Color505050])
        betAtt.append(bet)
        betLabel.attributedText = betAtt
    }
}
