//
//  WithdrawalProgressHeader.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class WithdrawalProgressHeader: UIView {

    public var progressModel: ProgressModel! {
        didSet{
            moneyLB.text = progressModel.amount
            stateLB.text = progressModel.status
        }
    }
    
    private var moneyLB: UILabel!
    private var stateLB: UILabel!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 125 * defaultScale))
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moneyLB.snp.makeConstraints { (make) in
            make.top.equalTo(29 * defaultScale)
            make.left.right.equalTo(self)
            make.height.equalTo(36 * defaultScale)
        }
        stateLB.snp.makeConstraints { (make) in
            make.top.equalTo(moneyLB.snp.bottom).offset(1)
            make.left.right.equalTo(moneyLB)
            make.height.equalTo(24 * defaultScale)
        }
    }
    
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        moneyLB = UILabel()
        moneyLB.font = Font36
        moneyLB.textColor = ColorEA5504
        moneyLB.textAlignment = .center
        moneyLB.text = "100.00"
        
        let moneyAtt = NSMutableAttributedString(string: "¥", attributes: [NSAttributedStringKey.font: Font14])
        
        
        
        stateLB = UILabel()
        stateLB.font = Font24
        stateLB.textColor = Color787878
        stateLB.textAlignment = .center
        stateLB.text = "处理中"
        
        self.addSubview(moneyLB)
        self.addSubview(stateLB)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
