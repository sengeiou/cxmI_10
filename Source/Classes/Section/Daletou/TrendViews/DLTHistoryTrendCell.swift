//
//  DLTHistoryTrendCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class DLTHistoryTrendCell: UITableViewCell {

    @IBOutlet weak var phaseNum: UILabel!
    
    @IBOutlet weak var redOne: UILabel!
    
    @IBOutlet weak var redTwo: UILabel!
    
    @IBOutlet weak var redThree: UILabel!
    
    @IBOutlet weak var redFour: UILabel!
    
    @IBOutlet weak var redFive: UILabel!
    
    @IBOutlet weak var blueOne: UILabel!
    
    @IBOutlet weak var blueTwo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
