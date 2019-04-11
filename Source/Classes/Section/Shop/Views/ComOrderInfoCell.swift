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
    
    public var numView : NumPlusReduceView!
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
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

extension ComOrderInfoCell {
    private func initSubview() {
        numView = NumPlusReduceView()
        self.contentView.addSubview(numView)
        numView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-20)
            make.right.equalTo(-15)
            make.width.equalTo(74)
            make.height.equalTo(22)
        }
    }
}
