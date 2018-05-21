//
//  AccountDetailFooterView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class AccountDetailFooterView: UIView {

    public var dataModel : AccountStatisticsModel! {
        didSet{
            guard dataModel != nil else { return }
            let rechargeAtt = NSMutableAttributedString(string: "充值 ")
            let recharge = NSAttributedString(string: dataModel.rechargeMoney + "元", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
            let withTitle = NSAttributedString(string: ",提现")
            let with = NSAttributedString(string: dataModel.withDrawMoney + "元", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
            let buyTitle = NSAttributedString(string: ",购彩")
            let buy = NSAttributedString(string:"" + dataModel.buyMoney + "元", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
            let reTitle = NSAttributedString(string: ",中奖")
            let reward = NSAttributedString(string:"" + dataModel.rewardMoney + "元", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
            rechargeAtt.append(recharge)
            rechargeAtt.append(withTitle)
            rechargeAtt.append(with)
            rechargeAtt.append(buyTitle)
            rechargeAtt.append(buy)
            rechargeAtt.append(reTitle)
            rechargeAtt.append(reward)
            
            
            rechargeLB.attributedText = rechargeAtt
        }
    }
    
    private var titleLB: UILabel!
    private var rechargeLB: UILabel!
//    private var withdrawalLB: UILabel!
//    private var buyLB: UILabel!
//    private var winLB: UILabel!
    
    private var bgView: UIView!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(1)
            make.left.right.equalTo(self)
            //make.height.equalTo(loginButHeight)
            make.bottom.equalTo(0)
        }
        
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(leftSpacing)
            make.width.equalTo(80)
            make.height.equalTo(10)
        }
        rechargeLB.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB.snp.bottom).offset(1)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.bottom.equalTo(-5)
            //make.height.equalTo(20)
        }
//        withdrawalLB.snp.makeConstraints { (make) in
//            make.top.equalTo(rechargeLB)
//            make.left.equalTo(rechargeLB.snp.right).offset(5)
//            make.right.equalTo(-rightSpacing)
//            make.width.equalTo(rechargeLB)
//        }
//        buyLB.snp.makeConstraints { (make) in
//            make.bottom.equalTo(-10)
//            make.left.width.height.equalTo(rechargeLB)
//        }
//        winLB.snp.makeConstraints { (make) in
//            make.bottom.equalTo(buyLB)
//            make.left.width.height.equalTo(buyLB)
//        }
    }
    private func initSubview() {
        titleLB = getLB()
        titleLB.text = "当月合计: "
        rechargeLB = getLB()
        rechargeLB.numberOfLines = 0
//        buyLB = getLB()
//        winLB = getLB()
//        withdrawalLB = getLB()
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        bgView.addSubview(titleLB)
        bgView.addSubview(rechargeLB)
//        bgView.addSubview(buyLB)
//        bgView.addSubview(winLB)
//        bgView.addSubview(withdrawalLB)
        
        self.addSubview(bgView)
        
    }
    
    private func getLB() -> UILabel {
        let lab = UILabel()
        lab.font = Font10
        lab.textColor = Color505050
        lab.textAlignment = .left
        //lab.text = "充值： 1000000000000"
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
