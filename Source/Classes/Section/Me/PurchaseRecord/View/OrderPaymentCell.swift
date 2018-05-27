//
//  OrderPaymentCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/24.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class OrderPaymentCell: UITableViewCell {

    public var orderInfo : OrderInfoModel! {
        didSet{
            guard orderInfo != nil else { return }
            if orderInfo.passType == nil || orderInfo.passType == "null" {
                orderInfo.passType = ""
            }

            //银行卡支付  ， 优惠券抵现
            let detailAtt = NSMutableAttributedString(string: "")
            
            if orderInfo.surplus > 0 {
                let surplusAtt = NSMutableAttributedString(string: "余额支付 ")
                let surplus = NSAttributedString(string: "\(orderInfo.surplus)", attributes: [NSAttributedStringKey.foregroundColor: Color505050])
                surplusAtt.append(surplus)
                detailAtt.append(surplusAtt)
            }
            if orderInfo.thirdPartyPaid > 0 {
                let paidAtt = NSMutableAttributedString(string: "\n银行卡支付 ")
                let paid = NSAttributedString(string: "\(orderInfo.thirdPartyPaid)", attributes: [NSAttributedStringKey.foregroundColor: Color505050])
                paidAtt.append(paid)
                detailAtt.append(paidAtt)
            }
            if orderInfo.bonus > 0 {
                let bonusAtt = NSMutableAttributedString(string: "\n优惠券抵现 ")
                let bonus = NSAttributedString(string: "\(orderInfo.bonus)", attributes: [NSAttributedStringKey.foregroundColor: Color505050])
                bonusAtt.append(bonus)
                detailAtt.append(bonusAtt)
            }
            
//            let money = NSAttributedString(string: " 20.00", attributes: [NSAttributedStringKey.foregroundColor: Color505050])
//            let details = NSAttributedString(string: orderInfo.cathectic, attributes: [NSAttributedStringKey.foregroundColor: Color505050])
//            detailAtt.append(details)
//            detailAtt.append(money)
            detail.attributedText = detailAtt
        }
    }
    
    private var title : UILabel!
    private var detail : UILabel!
    private var line : UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        title = UILabel()
        title.font = Font12
        title.textColor = ColorA0A0A0
        title.textAlignment = .left
        title.text = "支付方式:"
        title.sizeToFit()
        
        detail = UILabel()
        detail.font = Font12
        detail.textColor = ColorA0A0A0
        detail.textAlignment = .left
        //detail.text = "4注2倍"
        detail.numberOfLines = 0
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(title)
        self.contentView.addSubview(detail)
        
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(0)
            make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
            make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(16)
            make.height.equalTo(15)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.width.equalTo(55)
            
            //make.right.equalTo(self.contentView).offset(-rightSpacing)
        }
        detail.snp.makeConstraints { (make) in
            make.top.equalTo(title)
            make.bottom.equalTo(self.contentView).offset(-16)
            make.right.equalTo(0)
            make.left.equalTo(title.snp.right).offset(10)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
