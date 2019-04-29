//
//  CommodityInfoCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/30.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class CommodityInfoCell: UITableViewCell {

    @IBOutlet weak var goodsName : UILabel!
    @IBOutlet weak var salesNum : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}

extension CommodityInfoCell {
    public func configure(with data : GoodsDetailModel) {
        goodsName.text = data.description
        salesNum.text = data.paidNum + "人付款"
    }
}
