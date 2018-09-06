//
//  TeamDetailRecordCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class TeamDetailRecordCell: UITableViewCell {

    @IBOutlet weak var bottomLine : UIImageView!
    
    @IBOutlet weak var match : UILabel!
    
    @IBOutlet weak var dateLabel : UILabel!
    
    @IBOutlet weak var scoreLabel : UILabel!
    
    @IBOutlet weak var winLabel : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
