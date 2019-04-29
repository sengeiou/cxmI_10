//
//  LoLPlayConfirmSubCell.swift
//  彩小蜜
//
//  Created by 笑 on 2019/2/28.
//  Copyright © 2019 韩笑. All rights reserved.
//

import UIKit

class LoLPlayConfirmSubCell: UITableViewCell {

    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var betDetail : UILabel!
    
    @IBOutlet weak var topLine : UIView!
    @IBOutlet weak var bottomLine : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
