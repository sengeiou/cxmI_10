//
//  RechargePaymentTitleCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class RechargePaymentTitleCell: UITableViewCell {

    private var title : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(20)
            make.bottom.equalTo(self.contentView).offset(-20)
            make.left.equalTo(self.contentView).offset(19)
            make.right.equalTo(self.contentView)
        }
    }
    
    private func initSubview() {
        title = UILabel()
        title.text = "支付方式"
        title.textColor = Color505050
        title.font = Font15
        
        self.contentView.addSubview(title)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
