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
            if let url = URL(string: orderInfo.lotteryClassifyImg){
                icon.kf.setImage(with: url)
            }
            
            let moneyAtt = NSMutableAttributedString(string: "¥", attributes: [NSAttributedStringKey.font: Font10])
            let money = NSAttributedString(string: orderInfo.moneyPaid)
            moneyAtt.append(money)
            
            titleLB.text = orderInfo.lotteryClassifyName
            moneyLB.attributedText = moneyAtt
            state.text = orderInfo.processResult
            thankLB.text = orderInfo.processStatusDesc
            programmeLB.text = orderInfo.orderStatusDesc
            
        }
    }
    
    private var icon : UIImageView!
    private var titleLB : UILabel!
    private var moneyLB : UILabel!
    private var line : UIView!
    private var state : UILabel!
    private var programmeTitle : UILabel!
    private var programmeLB : UILabel!
    private var thankLB : UILabel!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: OrderHeaderViewHeight))
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        line.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY).offset(7.5)
            make.left.equalTo(self).offset(SeparatorLeftSpacing)
            make.right.equalTo(self).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
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
            make.left.right.equalTo(titleLB)
            make.height.equalTo(12)
        }
        state.snp.makeConstraints { (make) in
            make.top.height.equalTo(titleLB)
            make.right.equalTo(self).offset(-26)
            make.width.equalTo(100)
        }
        programmeTitle.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.left.equalTo(self).offset(26)
            make.width.equalTo(100)
            make.height.equalTo(12)
        }
        programmeLB.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.left.right.width.equalTo(programmeTitle)
            make.bottom.equalTo(self).offset(-10)
        }
        
        thankLB.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.right.equalTo(self).offset(-26)
            make.left.equalTo(programmeLB.snp.right).offset(10)
            make.bottom.equalTo(self).offset(-12)
        }
        
    }
    
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        icon = UIImageView()
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color505050
        titleLB.textAlignment = .left
        titleLB.text = "精彩足球"
        
        moneyLB = UILabel()
        moneyLB.font = Font12
        moneyLB.textColor = Color787878
        moneyLB.textAlignment = .left
        moneyLB.text = "¥ 25.00"
        
        state = UILabel()
        state.font = Font15
        state.textColor = Color505050
        state.textAlignment = .right
        state.text = "等待开奖"
        
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        programmeTitle = UILabel()
        programmeTitle.font = Font12
        programmeTitle.textColor = ColorA0A0A0
        programmeTitle.textAlignment = .left
        programmeTitle.text = "方案状态"
        
        programmeLB = UILabel()
        programmeLB.font = Font14
        programmeLB.textColor = Color505050
        programmeLB.textAlignment = .left
        programmeLB.text = "出票成功"
        
        thankLB = UILabel()
        thankLB.font = Font14
        thankLB.textColor = Color505050
        thankLB.textAlignment = .right
        thankLB.text = "感谢您助力公益事业"
        
        self.addSubview(icon)
        self.addSubview(titleLB)
        self.addSubview(moneyLB)
        self.addSubview(state)
        self.addSubview(programmeTitle)
        self.addSubview(programmeLB)
        self.addSubview(line)
        self.addSubview(thankLB)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
