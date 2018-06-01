//
//  CouponCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol CouponCellDelegate {
    func didTipUseButtong(_ cell : CouponCell, couponInfo: CouponInfoModel) -> Void
}

class CouponCell: UITableViewCell {

    public var couponInfo: CouponInfoModel! {
        didSet{
            guard couponInfo != nil else { return }
            var moneyColor : UIColor!
            overdue.text = ""
            switch couponInfo.bonusStatus {
            case "0":
                // 快过期标志：1-显示 0-隐藏 2- 未生效优惠券
                if couponInfo.soonExprireBz == "1" {
                    titleLB.textColor = Color505050
                    stateIcon.image = UIImage(named: "Expiresoon")
                    useBut.setTitleColor(ColorEA5504, for: .normal)
                    useBut.isUserInteractionEnabled = true
                }else if couponInfo.soonExprireBz == "2" {
                    stateIcon.image = UIImage(named: "weishengxiao")
                    useBut.setTitleColor(ColorA0A0A0, for: .normal)
                    useBut.isUserInteractionEnabled = false
                }else {
                    useBut.setTitleColor(ColorEA5504, for: .normal)
                    useBut.isUserInteractionEnabled = true
                }
                moneyColor = ColorE95504
                overdue.text = couponInfo.leaveTime
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
    
    public var delegate : CouponCellDelegate!
    
    private var bgImageView : UIImageView!
    private var moneyLB : UILabel!
    private var titleLB : UILabel!
    private var timeLB : UILabel!
    private var instructions : UILabel! // 使用说明
    private var stateIcon : UIImageView!
    private var overdue: UILabel!       // 快过期时间
    private var useBut: UIButton!       // 立即使用
    
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
            make.right.equalTo(useBut.snp.left).offset(5)
            make.bottom.equalTo(instructions.snp.top).offset(-5)
        }
        instructions.snp.makeConstraints { (make) in
            make.bottom.equalTo(overdue.snp.top).offset(-5)
            make.left.right.height.equalTo(timeLB)
            
        }
        overdue.snp.makeConstraints { (make) in
            //make.bottom.equalTo(instructions)
            make.left.right.height.equalTo(timeLB)
            make.bottom.equalTo(-17.5)
        }
        useBut.snp.makeConstraints { (make) in
            make.bottom.equalTo(-17.5)
            make.right.equalTo(-rightSpacing)
            make.width.equalTo(80)
            make.top.equalTo(timeLB)
        }
    }
    
    
    private func initSubview() {
        self.selectionStyle = .none
        
        bgImageView = UIImageView()
        bgImageView.isUserInteractionEnabled = true
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
        
        overdue = UILabel()
        overdue.font = Font12
        overdue.textColor = ColorA0A0A0
        overdue.textAlignment = .left
        overdue.text = "剩余2天到期"
        
        useBut = UIButton(type: .custom)
        useBut.setTitle("立即使用", for: .normal)
        useBut.contentHorizontalAlignment = .right
        useBut.contentVerticalAlignment = .center
        useBut.titleLabel?.font = Font14
        //useBut.titleLabel?.sizeToFit()
        useBut.setTitleColor(ColorEA5504, for: .normal)
        useBut.addTarget(self, action: #selector(useButClicked(_:)), for: .touchUpInside)
        
        self.contentView.addSubview(bgImageView)
        bgImageView.addSubview(moneyLB)
        bgImageView.addSubview(titleLB)
        bgImageView.addSubview(timeLB)
        bgImageView.addSubview(instructions)
        bgImageView.addSubview(stateIcon)
        bgImageView.addSubview(overdue)
        bgImageView.addSubview(useBut)
        
    }
    
    @objc private func useButClicked(_ sender: UIButton ) {
        guard delegate != nil else { return }
        delegate.didTipUseButtong(self, couponInfo: self.couponInfo)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
