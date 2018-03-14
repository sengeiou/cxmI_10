//
//  RechargeCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

let RechargeCellIdentifier = "rechargeCellIdentifier"
class RechargeCell: UITableViewCell {

    
    //MARK: - 属性
    private var icon : UIImageView!
    private var title : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        icon = UIImageView()
        icon.image = UIImage(named: "userID")
        
        title = UILabel()
        title.font = Font14
        title.textColor = UIColor.black
        title.text = "微信支付"
        title.textAlignment = .left
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.left.equalTo(self.contentView).offset(10)
            make.width.equalTo(icon.snp.height)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.left.equalTo(icon.snp.right).offset(30)
            make.right.equalTo(self.contentView).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
