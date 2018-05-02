//
//  RechargePaymentCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

let RechargeCellIdentifier = "rechargeCellIdentifier"
class RechargePaymentCell: UITableViewCell {

    public var paymentInfo : PaymentList! {
        didSet{
            title.text = paymentInfo.payName
            
        }
    }
    
    //MARK: - 属性
    private var icon : UIImageView!
    private var title : UILabel!
    private var selectorIcon : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        icon = UIImageView()
        icon.image = UIImage(named: "WeChatrecharge")
        
        selectorIcon = UIImageView()
        selectorIcon.image = UIImage(named: "chargesure")
        
        title = UILabel()
        title.font = Font15
        title.textColor = Color505050
        title.text = "微信支付"
        title.textAlignment = .left
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        self.contentView.addSubview(selectorIcon)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(13.5)
            make.bottom.equalTo(self.contentView).offset(-13.5)
            make.left.equalTo(self.contentView).offset(19)
            make.width.equalTo(icon.snp.height)
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.left.equalTo(icon.snp.right).offset(8.5)
            make.right.equalTo(selectorIcon.snp.left).offset(-10)
        }
        selectorIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(self.contentView).offset(-21)
            make.height.width.equalTo(21)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            selectorIcon.image = UIImage(named: "chargesure")
        }else {
            selectorIcon.image = UIImage(named: "butongyi")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
