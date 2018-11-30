//
//  ComOrderInfoCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/28.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class ComOrderInfoCell: UITableViewCell {

    @IBOutlet weak var icon : UIImageView!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var price : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ComOrderInfoCell {
    public func configure(with data : GoodsOrderDetail) {
        if let url = URL(string: data.orderPic){
            icon.kf.setImage(with: url)
        }
        title.text = data.description
        price.text = "¥ " + data.price
    }
}
