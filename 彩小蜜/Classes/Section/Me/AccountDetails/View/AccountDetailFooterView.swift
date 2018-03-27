//
//  AccountDetailFooterView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class AccountDetailFooterView: UIView {

    private var titleLB: UILabel!
    private var rechargeLB: UILabel!
    private var withdrawalLB: UILabel!
    private var buyLB: UILabel!
    private var winLB: UILabel!
    
    private var bgView: UIView!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 90))
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(loginButTopSpacing)
            make.left.right.equalTo(self)
            make.height.equalTo(60)
        }
        
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(leftSpacing)
            make.width.equalTo(60)
            make.height.equalTo(20)
        }
        rechargeLB.snp.makeConstraints { (make) in
            make.top.equalTo(titleLB)
            make.left.equalTo(titleLB.snp.right).offset(5)
            make.height.equalTo(20)
        }
        withdrawalLB.snp.makeConstraints { (make) in
            make.top.equalTo(rechargeLB)
            make.left.equalTo(rechargeLB.snp.right).offset(5)
            make.right.equalTo(-rightSpacing)
            make.width.equalTo(rechargeLB)
        }
        buyLB.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.left.width.height.equalTo(rechargeLB)
        }
        winLB.snp.makeConstraints { (make) in
            make.bottom.equalTo(buyLB)
            make.left.width.height.equalTo(buyLB)
        }
    }
    private func initSubview() {
        titleLB = getLB()
        rechargeLB = getLB()
        buyLB = getLB()
        winLB = getLB()
        withdrawalLB = getLB()
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        bgView.addSubview(titleLB)
        bgView.addSubview(rechargeLB)
        bgView.addSubview(buyLB)
        bgView.addSubview(winLB)
        bgView.addSubview(withdrawalLB)
        
        self.addSubview(bgView)
        
    }
    
    private func getLB() -> UILabel {
        let lab = UILabel()
        lab.font = Font15
        lab.textColor = Color505050
        lab.textAlignment = .left
        lab.text = "充值： 1000000000000"
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
