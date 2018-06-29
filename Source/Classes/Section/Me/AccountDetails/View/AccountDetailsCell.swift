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
            guard accountDetail != nil else { return }
            titleLB.text = accountDetail.processTypeName
            detailLB.text = accountDetail.note
            moneyLB.text = accountDetail.changeAmount
            timeLB.text = accountDetail.shotTime
            
            stateLB.text = accountDetail.status
            
            stateLB.isHidden = true
            stateIcon.isHidden = true
            // 0-全部 1-奖金 2-充值 3-购彩 4-提现 5-红包 6- 退款
            moneyLB.textColor = Color505050
            moneyLB.snp.remakeConstraints { (make) in
                make.height.top.equalTo(titleLB)
                make.right.equalTo(self.contentView).offset(-rightSpacing)
                make.left.equalTo(titleLB.snp.right).offset(10)
                make.width.equalTo(titleLB)
            }
            
            switch accountDetail.processType {
            case "1":
                icon.image = UIImage(named: "Thewinning")
                moneyLB.textColor = ColorEA5504
            case "2":
                icon.image = UIImage(named: "top-up")
            case "3":
                icon.image = UIImage(named: "Buyticket")
            case "4":
                stateLB.isHidden = false
                stateIcon.isHidden = false
                icon.image = UIImage(named: "withdrawal")
               
                moneyLB.snp.remakeConstraints { (make) in
                    make.height.top.equalTo(titleLB)
                    make.right.equalTo(stateIcon.snp.left).offset(-1)
                    make.left.equalTo(titleLB.snp.right).offset(10)
                    make.width.equalTo(titleLB)
                }
                
            case "5":
                icon.image = UIImage(named: "")
            case "6":
                icon.image = UIImage(named: "refund")
            default: break
            }
            
        }
    }
    
    public var line : UIImageView!
    
    private var icon : UIImageView!
    private var titleLB : UILabel!
    private var detailLB: UILabel!
    private var moneyLB: UILabel!
    private var stateLB: UILabel!
    private var stateIcon : UIImageView!
    private var timeLB: UILabel!
    
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
        titleLB.font = Font14
        titleLB.textColor = Color505050
        titleLB.textAlignment = .left
        //titleLB.text = "微信充值"
        
        detailLB = UILabel()
        detailLB.font = Font10
        detailLB.textColor = Color787878
        detailLB.textAlignment = .left
        detailLB.numberOfLines = 0
//        detailLB.text = """
//        微信支付1.5元
//        余额支付1.5元
//        红包抵扣2.5元
//        14 ：00 ：36
//        """
        
        timeLB = UILabel()
        timeLB.font = Font10
        timeLB.textColor = ColorA0A0A0
        timeLB.textAlignment = .left
        
        moneyLB = UILabel()
        moneyLB.font = Font14
        moneyLB.textColor = Color505050
        moneyLB.textAlignment = .right
        //moneyLB.text = "+ ¥ 1,000.00"
        
        stateLB = UILabel()
        stateLB.font = Font14
        stateLB.textColor = ColorA0A0A0
        stateLB.textAlignment = .right
        //stateLB.text = "提现成功"
        
        stateIcon = UIImageView()
        stateIcon.image = UIImage(named: "jump")
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(icon)
        self.contentView.addSubview(titleLB)
        self.contentView.addSubview(detailLB)
        self.contentView.addSubview(moneyLB)
        self.contentView.addSubview(stateLB)
        self.contentView.addSubview(stateIcon)
        self.contentView.addSubview(timeLB)
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(SeparatorLeftSpacing)
            make.right.equalTo(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(12.5 * defaultScale)
            make.left.equalTo(leftSpacing)
            make.width.height.equalTo(36 * defaultScale)
        }
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(16 * defaultScale)
            make.left.equalTo(icon.snp.right).offset(8 * defaultScale)
            make.height.equalTo(14 * defaultScale)
        }
        detailLB.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB.snp.bottom).offset(5)
            make.bottom.equalTo(timeLB.snp.top).offset(-5)
            make.left.right.equalTo(titleLB)
        }
        timeLB.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView).offset(-12.5 * defaultScale)
            make.left.right.equalTo(titleLB)
            make.height.equalTo(10)
        }
        
        moneyLB.snp.makeConstraints { (make) in
            make.height.top.equalTo(titleLB)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.left.equalTo(titleLB.snp.right).offset(10)
            make.width.equalTo(titleLB)
        }
        
        stateLB.snp.makeConstraints { (make) in
            make.top.equalTo(detailLB)
            make.right.equalTo(stateIcon.snp.left).offset(-1)
            make.width.equalTo(100)
            make.height.equalTo(15)
        }
        stateIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(moneyLB.snp.centerY)
            make.height.width.equalTo(11)
            make.right.equalTo(-(rightSpacing - 2))
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
