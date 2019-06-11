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
            guard paymentInfo != nil else { return }
            title.text = paymentInfo.payName
            if let url = URL(string: paymentInfo.payImg) {
                icon.kf.setImage(with: url)
            }
            if paymentInfo.payDesc != ""{
                payDesc.text = paymentInfo.payDesc
                upPayDescConstraints()
            }else{
                onlyTitleConstraints()
            }
        }
    }
    
    //MARK: - 属性
    private var icon : UIImageView!
    private var title : UILabel!
    private var payDesc : UILabel!
    private var selectorIcon : UIImageView!
    private var lineView : UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        
        payDesc = UILabel()
        payDesc.font = Font15
        payDesc.textColor = Color505050
        payDesc.text = "微信支付"
        payDesc.textAlignment = .left
        
        lineView = UIView()
        lineView.backgroundColor = .lightGray
        
        self.contentView.addSubview(icon)
        self.contentView.addSubview(title)
        self.contentView.addSubview(payDesc)
        self.contentView.addSubview(selectorIcon)
        self.contentView.addSubview(lineView)
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
            make.left.equalTo(icon.snp.right).offset(8.5)
            make.right.equalTo(selectorIcon.snp.left).offset(-10)
        }
        selectorIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(self.contentView).offset(-21)
            make.height.width.equalTo(21)
        }
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.top.left.right.equalTo(self.contentView)
        }
    }
    
    private func upPayDescConstraints(){
        title.font = Font14
        payDesc.font = Font10
        
        title.snp.remakeConstraints { (make) in
         make.top.equalTo(self.contentView).offset(8.5)
            make.left.equalTo(icon.snp.right).offset(8.5)
            make.right.equalTo(selectorIcon.snp.left).offset(-10)
        }
        payDesc.numberOfLines = 0
        payDesc.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.left.equalTo(icon.snp.right).offset(8.5)
            make.right.equalTo(selectorIcon.snp.left).offset(-10)
        }
    }
    
    private func onlyTitleConstraints(){
        title.font = Font15
        title.snp.remakeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.left.equalTo(icon.snp.right).offset(8.5)
            make.right.equalTo(selectorIcon.snp.left).offset(-10)
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
