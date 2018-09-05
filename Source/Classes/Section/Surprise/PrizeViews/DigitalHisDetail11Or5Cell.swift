//
//  DigitalHisDetail11Or5Cell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DigitalHisDetail11Or5Cell: UITableViewCell {

    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var leftLine: UIView!
    
    @IBOutlet weak var rightLine: UIView!
    
    @IBOutlet weak var prizeLabel : UILabel!
    
    @IBOutlet weak var amountLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
