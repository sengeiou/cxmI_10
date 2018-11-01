//
//  OrderDetailHeaderView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit


class OrderDetailHeaderView: UIView {

    public var orderInfo: OrderInfoModel! {
        didSet{
            guard orderInfo != nil else { return }
            if let url = URL(string: orderInfo.lotteryClassifyImg){
                icon.kf.setImage(with: url)
            }
            //icon.image = UIImage(named: "Racecolorfootball")
            
            
            let moneyAtt = NSMutableAttributedString(string: "¥", attributes: [NSAttributedStringKey.font: Font10])
            let money = NSAttributedString(string: orderInfo.ticketAmount)
            moneyAtt.append(money)
            
            titleLB.text = orderInfo.lotteryClassifyName
            moneyLB.attributedText = moneyAtt
            programmeLB.text = orderInfo.orderStatusDesc
            forecastMoney.text = orderInfo.forecastMoney
            
            if orderInfo.orderStatus == "5" {
                setWinMoney()
                winMoney.text = "¥ " + orderInfo.processStatusDesc
                state.text = orderInfo.orderStatusDesc
                state.textColor = ColorEA5504
            }else {
                thankLB.text = orderInfo.processStatusDesc
                state.text = orderInfo.processResult
            }
            
        }
    }
    
    private var icon : UIImageView!
    private var titleLB : UILabel!
    private var moneyLB : UILabel!
    private var line : UIView!
    private var state : UILabel!
    private var forecastMoney: UILabel!
    private var programmeTitle : UILabel!
    private var programmeLB : UILabel!
    private var thankLB : UILabel!
    
    private var winTitle: UILabel!
    private var winMoney: UILabel!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: OrderHeaderViewHeight))
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        line.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self.snp.centerY).offset(7.5)
            make.left.equalTo(self).offset(SeparatorLeftSpacing)
            make.right.equalTo(self).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
            make.bottom.equalTo(0)
        }
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(11)
            make.left.equalTo(self).offset(16)
            make.bottom.equalTo(line.snp.top).offset(-11)
            make.width.equalTo(icon.snp.height)
        }
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(18)
            make.left.equalTo(icon.snp.right).offset(10)
            make.right.equalTo(state.snp.left).offset(-5)
            make.height.equalTo(15)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.bottom.equalTo(line.snp.top).offset(-16)
            make.left.equalTo(titleLB)
           
            //make.right.equalTo(self.snp.centerX).offset(-50)
            make.height.equalTo(12)
        }
        state.snp.makeConstraints { (make) in
            make.top.height.equalTo(titleLB)
            make.right.equalTo(self).offset(-26)
            make.width.equalTo(100)
        }
        forecastMoney.snp.makeConstraints { (make) in
            make.top.equalTo(state.snp.bottom).offset(1)
            make.bottom.equalTo(line.snp.top).offset(-1)
            //make.right.width.equalTo(state)
            //make.width.equalTo(moneyLB)
            make.left.equalTo(moneyLB.snp.right).offset(10)
            make.right.equalTo(state)
        }
//        programmeTitle.snp.makeConstraints { (make) in
//            make.top.equalTo(line.snp.bottom).offset(10)
//            make.left.equalTo(self).offset(26)
//            make.width.equalTo(100)
//            make.height.equalTo(12)
//        }
//        programmeLB.snp.makeConstraints { (make) in
//            make.height.equalTo(19)
//            make.left.right.width.equalTo(programmeTitle)
//            make.bottom.equalTo(self).offset(-10)
//        }
//
//        thankLB.snp.makeConstraints { (make) in
//            make.height.equalTo(19)
//            make.right.equalTo(self).offset(-26)
//            make.left.equalTo(programmeLB.snp.right).offset(10)
//            make.bottom.equalTo(self).offset(-12)
//        }
        
    }
    
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        icon = UIImageView()
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color505050
        titleLB.textAlignment = .left
        //titleLB.text = "精彩足球"
        
        moneyLB = UILabel()
        moneyLB.font = Font12
        moneyLB.textColor = Color787878
        moneyLB.textAlignment = .left
        //moneyLB.text = "¥ 25.00"
        
        state = UILabel()
        state.font = Font15
        state.textColor = Color505050
        state.textAlignment = .right
        //state.text = "等待开奖"
        
        forecastMoney = UILabel()
        forecastMoney.font = Font12
        forecastMoney.textColor = ColorEA5504
        forecastMoney.textAlignment = .right
        
        
        
        line = UIView()
        line.backgroundColor = ColorE9E9E9
        
        programmeTitle = UILabel()
        programmeTitle.font = Font12
        programmeTitle.textColor = ColorA0A0A0
        programmeTitle.textAlignment = .left
        programmeTitle.text = "方案状态"
        
        programmeLB = UILabel()
        programmeLB.font = Font14
        programmeLB.textColor = Color505050
        programmeLB.textAlignment = .left
        
        
        thankLB = UILabel()
        thankLB.font = Font14
        thankLB.textColor = Color505050
        thankLB.textAlignment = .right
       
        
        self.addSubview(icon)
        self.addSubview(titleLB)
        self.addSubview(moneyLB)
        self.addSubview(state)
        self.addSubview(programmeTitle)
        self.addSubview(programmeLB)
        self.addSubview(line)
        self.addSubview(thankLB)
        self.addSubview(forecastMoney)
    }
    
    private func setWinMoney() {
        winMoney = UILabel()
        winMoney.font = Font12
        winMoney.textColor = ColorEA5504
        winMoney.textAlignment = .right
        
        
        winTitle = UILabel()
        winTitle.font = Font12
        winTitle.textColor = ColorA0A0A0
        winTitle.textAlignment = .right
        winTitle.text = "中奖金额"
        
        self.addSubview(winMoney)
        self.addSubview(winTitle)
        
        winTitle.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(5)
            make.right.equalTo(-rightSpacing)
            make.width.equalTo(100)
        }
        winMoney.snp.makeConstraints { (make) in
            make.top.equalTo(winTitle.snp.bottom).offset(1)
            make.bottom.equalTo(-5)
            make.right.equalTo(winTitle)
            make.left.equalTo(programmeTitle.snp.right).offset(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
