//
//  CouponCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {

    public var couponInfo: CouponInfoModel! {
        didSet{
            guard couponInfo != nil else { return }
            var moneyColor : UIColor!
            
            switch couponInfo.bonusStatus {
            case "0":
                // 快过期标志：1-显示 0-隐藏
                if couponInfo.soonExprireBz == "1" {
                    titleLB.textColor = Color505050
                    stateIcon.image = UIImage(named: "Expiresoon")
                }else if couponInfo.soonExprireBz == "2" {
                    stateIcon.image = UIImage(named: "Expiresoon")
                }else {
                    
                }
                moneyColor = ColorE95504
            case "1":
                moneyColor = Color787878
                titleLB.textColor = Color505050
                stateIcon.image = UIImage(named: "used")
            case "2":
                moneyColor = ColorA0A0A0
                titleLB.textColor = ColorA0A0A0
                stateIcon.image = UIImage(named: "Expired")
            default: break
                
            }
            
           
            
            let moneyAtt = NSMutableAttributedString(string: "¥", attributes: [NSAttributedStringKey.font: Font18, NSAttributedStringKey.foregroundColor: moneyColor])
            let money = NSAttributedString(string: couponInfo.bonusPrice, attributes: [NSAttributedStringKey.foregroundColor: moneyColor])
            moneyAtt.append(money)
            
            let timeAtt = NSMutableAttributedString(string: "有效期: ")
            let time = NSAttributedString(string: couponInfo.limitTime, attributes: [NSAttributedStringKey.foregroundColor: ColorA0A0A0])
            timeAtt.append(time)
            
            let insAtt = NSMutableAttributedString(string: "使用说明: ")
            let ins = NSAttributedString(string: couponInfo.useRange, attributes: [NSAttributedStringKey.foregroundColor: ColorA0A0A0])
            insAtt.append(ins)
            
            moneyLB.attributedText = moneyAtt
            titleLB.text = couponInfo.minGoodsAmount
            timeLB.attributedText = timeAtt
            instructions.attributedText = insAtt
            
            
        }
    }
    
    
    private var bgImageView : UIImageView!
    private var moneyLB : UILabel!
    private var titleLB : UILabel!
    private var timeLB : UILabel!
    private var instructions : UILabel!
    private var stateIcon : UIImageView!
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = ColorF4F4F4
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(7.5)
            make.right.equalTo(self.contentView).offset(-7.5)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView)
            make.bottom.equalTo(bgImageView.snp.centerY)
            make.left.equalTo(bgImageView).offset(leftSpacing)
            make.width.equalTo(150)
        }
        titleLB.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(moneyLB)
            make.left.equalTo(moneyLB.snp.right).offset(10)
            make.right.equalTo(stateIcon.snp.left).offset(-1)
        }
        stateIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.top.equalTo(bgImageView)
            make.right.equalTo(bgImageView)
        }
        timeLB.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.left.equalTo(moneyLB)
            make.right.equalTo(bgImageView)
            make.bottom.equalTo(instructions.snp.top).offset(-5)
        }
        instructions.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgImageView).offset(-17.5)
            make.left.right.height.equalTo(timeLB)
        }
        
    }
    
    
    private func initSubview() {
        self.selectionStyle = .none
        
        bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "couponBg")
        
        moneyLB = UILabel()
        moneyLB.font = Font30
        moneyLB.textColor = ColorE95504
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color505050
        titleLB.numberOfLines = 0
        
        timeLB = UILabel()
        timeLB.font = Font10
        timeLB.textColor = ColorC8C8C8
        
        instructions = UILabel()
        instructions.font = Font10
        instructions.textColor = ColorC8C8C8
        
        stateIcon = UIImageView()
        
        
        
        self.contentView.addSubview(bgImageView)
        bgImageView.addSubview(moneyLB)
        bgImageView.addSubview(titleLB)
        bgImageView.addSubview(timeLB)
        bgImageView.addSubview(instructions)
        bgImageView.addSubview(stateIcon)
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
