//
//  AccountDetailsCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class AccountDetailsCell: UITableViewCell {

    public var accountDetail : AccountDetailModel! {
        didSet{
            titleLB.text = accountDetail.note
            detailLB.text = accountDetail.shotTime
            moneyLB.text = accountDetail.changeAmount
        }
    }
    
    public var line : UIImageView!
    
    private var icon : UIImageView!
    private var titleLB : UILabel!
    private var detailLB: UILabel!
    private var moneyLB: UILabel!
    private var stateLB: UILabel!
    private var stateIcon : UIImageView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        line = UIImageView()
        line.image = UIImage(named: "line")
        
        icon = UIImageView()
        icon.image = UIImage(named: "足球")
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color505050
        titleLB.textAlignment = .left
        titleLB.text = "微信充值"
        
        detailLB = UILabel()
        detailLB.font = Font10
        detailLB.textColor = ColorA0A0A0
        detailLB.textAlignment = .left
        detailLB.numberOfLines = 0
        detailLB.text = """
        微信支付1.5元
        余额支付1.5元
        红包抵扣2.5元
        14 ：00 ：36
        """
        
        moneyLB = UILabel()
        moneyLB.font = Font12
        moneyLB.textColor = Color505050
        moneyLB.textAlignment = .right
        moneyLB.text = "+ ¥ 1,000.00"
        
        stateLB = UILabel()
        stateLB.font = Font12
        stateLB.textColor = ColorA0A0A0
        stateLB.textAlignment = .right
        stateLB.text = "提现成功"
        
        stateIcon = UIImageView()
        stateIcon.image = UIImage(named: "jump")
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(icon)
        self.contentView.addSubview(titleLB)
        self.contentView.addSubview(detailLB)
        self.contentView.addSubview(moneyLB)
        self.contentView.addSubview(stateLB)
        self.contentView.addSubview(stateIcon)
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(SeparatorLeftSpacing)
            make.right.equalTo(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.left.equalTo(leftSpacing)
            make.width.height.equalTo(40)
        }
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(12)
            make.left.equalTo(icon.snp.right).offset(10)
            make.height.equalTo(20)
        }
        detailLB.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB.snp.bottom).offset(5)
            make.bottom.equalTo(self.contentView).offset(-5)
            make.left.right.equalTo(titleLB)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.height.top.equalTo(titleLB)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.left.equalTo(titleLB.snp.right).offset(10)
            make.width.equalTo(titleLB)
        }
        stateLB.snp.makeConstraints { (make) in
            make.top.equalTo(detailLB)
            make.right.equalTo(stateIcon.snp.left).offset(-5)
            make.width.equalTo(100)
            make.height.equalTo(15)
        }
        stateIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(stateLB.snp.centerY)
            make.height.width.equalTo(12)
            make.right.equalTo(-rightSpacing)
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
