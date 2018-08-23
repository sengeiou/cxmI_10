//
//  RechargeHeaderView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit


class RechargeHeaderView: UIView {
    //MARK: - 属性
    
    private var alertTitle : UILabel! // 警告语
    
    //MARK: - 初始化
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: Int(screenWidth), height: 66))
        
        initSubview()
    }
    
    private func initSubview() {
        alertTitle = UILabel()
        alertTitle.text = "提示: 充值金额可购彩但不能提现，中奖奖金可提现"
        alertTitle.font = Font13
        alertTitle.textColor = ColorF7931E
        alertTitle.numberOfLines = 2
        alertTitle.textAlignment = .center
        
        self.addSubview(alertTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        alertTitle.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self).offset(-17.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
