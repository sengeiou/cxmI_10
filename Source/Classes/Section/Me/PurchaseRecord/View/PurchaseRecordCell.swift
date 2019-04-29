//
//  PurchaseRecordCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class PurchaseRecordCell: UITableViewCell {

    public var recordInfo : PurchaseRecordInfoModel! {
        didSet{
            guard recordInfo != nil else { return }
            let moneyAtt = NSMutableAttributedString(string: "¥", attributes: [NSAttributedString.Key.font: Font11])
            let money = NSAttributedString(string: recordInfo.ticketAmount)
            moneyAtt.append(money)
            moneyLB.attributedText = moneyAtt
            
            titleLB.text = recordInfo.lotteryName
            timeLB.text = recordInfo.payTime
            detailLB.text = recordInfo.orderStatusInfo
            stateBut.text = recordInfo.orderStatusDesc
            
            detailLB.font = Font10
            detailLB.textColor = ColorA0A0A0
            
            switch recordInfo.orderStatus {
            case "0":
                stateBut.textColor = Color505050
                stateIcon.image = UIImage(named: "jump")
            case "1":
                stateBut.textColor = Color505050
                stateIcon.image = UIImage(named: "jump")
            case "2": // 出票失败
                stateBut.textColor = ColorA0A0A0
                stateIcon.image = UIImage(named: "jump")
            case "3": // 待开奖
                stateBut.textColor = Color505050
                stateIcon.image = UIImage(named: "jump")
            case "4": // 未中奖
                stateBut.textColor = ColorA0A0A0
                stateIcon.image = UIImage(named: "jump")
            case "5": // 已中奖
                stateBut.textColor = ColorE95504
                detailLB.font = Font15
                detailLB.textColor = ColorE95504
                stateIcon.image = UIImage(named: "redarrow")
            default: break
                
            }
        }
    }
    
    // MARK: - 点击事件
    
    
    // MARK: - 属性
    private var titleLB : UILabel!
    private var moneyLB : UILabel!
    private var timeLB : UILabel!
    private var stateBut : UILabel!
    private var stateIcon : UIImageView!
    private var detailLB : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLB.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.top.equalTo(self.contentView).offset(12)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.right.equalTo(stateBut.snp.left).offset(-10)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(titleLB)
            make.top.equalTo(titleLB.snp.bottom).offset(3)
        }
        timeLB.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(titleLB)
            make.top.equalTo(moneyLB.snp.bottom).offset(3)
        }
        stateBut.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(titleLB)
            make.right.equalTo(stateIcon.snp.left).offset(1)
        }
        stateIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-12)
            make.centerY.equalTo(stateBut.snp.centerY)
            make.height.width.equalTo(14)
        }
        detailLB.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.width.equalTo(timeLB)
            make.height.equalTo(20)
            make.top.equalTo(timeLB)
        }
        
        
    }
    private func initSubview() {
        self.selectionStyle = .none
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color505050
    
        moneyLB = UILabel()
        moneyLB.font = Font12
        moneyLB.textColor = Color787878

        timeLB = UILabel()
        timeLB.font = Font10
        timeLB.textColor = ColorA0A0A0
        
        stateBut = UILabel()
        stateBut.font = Font15
        stateBut.textAlignment = .right
        
        stateIcon = UIImageView()
        stateIcon.image = UIImage(named: "redarrow")
        
        detailLB = UILabel()
        detailLB.font = Font10
        detailLB.textColor = ColorA0A0A0
        detailLB.textAlignment = .right

        
        self.contentView.addSubview(titleLB)
        self.contentView.addSubview(moneyLB)
        self.contentView.addSubview(timeLB)
        self.contentView.addSubview(stateBut)
        self.contentView.addSubview(stateIcon)
        self.contentView.addSubview(detailLB)
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
