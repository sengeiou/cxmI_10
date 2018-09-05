//
//  DigitalHisLottoTitleCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DigitalHisLottoTitleCell: UITableViewCell {

    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var leftLine: UIView!
    
    @IBOutlet weak var rightLine: UIView!
    
    @IBOutlet weak var sellAmountTitle : UILabel!
    @IBOutlet weak var sellAmount : UILabel!
    
    @IBOutlet weak var prizesTiltle : UILabel!
    @IBOutlet weak var prizes : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DigitalHisLottoTitleCell {
    public func configure(with sell : String, prize : String) {
        sellAmount.text = sell
        prizes.text = prize
    }
}

