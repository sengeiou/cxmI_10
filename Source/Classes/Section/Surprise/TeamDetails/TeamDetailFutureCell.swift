//
//  TeamDetailFutureCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class TeamDetailFutureCell: UITableViewCell {
    @IBOutlet weak var topline : UIView!
    @IBOutlet weak var bottomLine : UIView!
    @IBOutlet weak var leftLine : UIView!
    @IBOutlet weak var rightLine : UIView!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var leagueName : UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var visiLabel: UILabel!
    @IBOutlet weak var vsLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
