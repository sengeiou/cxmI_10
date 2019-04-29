//
//  SellerListCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/29.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class SellerListCell: UITableViewCell {

    @IBOutlet weak var icon : UIImageView!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var detail : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }

    private func initSubview() {
        
    }
}

extension SellerListCell {
    public func configure(with data : SellerInfoModel) {
        if let url = URL(string: data.logo) {
            icon.kf.setImage(with: url)
        }
        
        title.text = data.name
        detail.text = "有\(data.collNum)名用户访问过此店铺"
        
    }
}
