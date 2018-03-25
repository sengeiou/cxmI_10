//
//  OrderDetailHeaderView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class OrderDetailHeaderView: UIView {

    private var icon : UIImageView!
    private var titleLB : UILabel!
    private var moneyLB : UILabel!
    private var line : UIView!
    private var state : UILabel!
    private var programmeTitle : UILabel!
    private var programmeLB : UILabel!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 111))
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        line.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self).offset(SeparatorLeftSpacing)
            make.right.equalTo(self).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        icon.snp.makeConstraints { (make) in
            //make.height.width.equalTo(40)
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(line.snp.top).offset(-10)
            make.width.equalTo(icon.snp.height)
        }
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(14)
            make.left.equalTo(icon.snp.right).offset(10)
            make.right.equalTo(state.snp.left).offset(-5)
            make.height.equalTo(20)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB.snp.bottom).offset(1)
            make.left.right.height.equalTo(titleLB)
        }
        state.snp.makeConstraints { (make) in
            make.top.height.equalTo(titleLB)
            make.right.equalTo(self).offset(-rightSpacing)
            make.width.equalTo(100)
        }
        programmeTitle.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(1)
            make.left.equalTo(self).offset(leftSpacing)
            make.right.equalTo(self).offset(-rightSpacing)
            
        }
        programmeLB.snp.makeConstraints { (make) in
            make.top.equalTo(programmeTitle.snp.bottom).offset(1)
            make.left.right.width.equalTo(programmeTitle)
            make.bottom.equalTo(self).offset(-1)
        }
    }
    
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        icon = UIImageView()
        icon.image = UIImage(named: "足球")
        
        titleLB = UILabel()
        titleLB.font = Font15
        titleLB.textColor = Color505050
        titleLB.textAlignment = .left
        titleLB.text = "精彩足球"
        
        moneyLB = UILabel()
        moneyLB.font = Font15
        moneyLB.textColor = ColorA0A0A0
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
        programmeTitle.font = Font15
        programmeTitle.textColor = ColorA0A0A0
        programmeTitle.textAlignment = .left
        programmeTitle.text = "方案状态"
        
        programmeLB = UILabel()
        programmeLB.font = Font15
        programmeLB.textColor = Color505050
        programmeLB.textAlignment = .left
        programmeLB.text = "出票成功"
        
        
        self.addSubview(icon)
        self.addSubview(titleLB)
        self.addSubview(moneyLB)
        self.addSubview(state)
        self.addSubview(programmeTitle)
        self.addSubview(programmeLB)
        self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
