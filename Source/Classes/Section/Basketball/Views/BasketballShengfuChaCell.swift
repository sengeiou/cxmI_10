//
//  BasketballShengfuChaCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BasketballShengfuChaCell: UITableViewCell {

    // 单关标识
    @IBOutlet weak var singleImg : UIImageView!
    
    @IBOutlet weak var oddsLabel : UILabel!
    @IBOutlet weak var oddsButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BasketballShengfuChaCell {
    public func configure(with data : BasketballListModel) {
        
    }
}
