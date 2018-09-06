//
//  TeamDetailMemberCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class TeamDetailMemberCell: UITableViewCell {

    @IBOutlet weak var topline : UIView!
    @IBOutlet weak var bottomLine : UIView!
    @IBOutlet weak var leftLine : UIView!
    @IBOutlet weak var rightLine : UIView!
    
    @IBOutlet weak var memberOne : UILabel!
    @IBOutlet weak var memberTwo : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
