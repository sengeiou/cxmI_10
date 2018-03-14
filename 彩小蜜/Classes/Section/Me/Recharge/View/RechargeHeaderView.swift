//
//  RechargeHeaderView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit


class RechargeHeaderView: UIView {

    fileprivate let iconHeight = 40
    fileprivate let titleHeight = 40
    fileprivate let accountHeight = 20
    fileprivate let balanceHeight = 20
    fileprivate let rowSpacing = 10
    
    //MARK: - 属性
    
    private var alertIcon : UIImageView! // 警告图标
    private var alertTitle : UILabel! // 警告语
    private var lineView : UIView! //分割线
    private var account : UILabel! // 账号
    private var balance : UILabel! // 余额
    
    //MARK: - 初始化
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: Int(screenWidth), height: titleHeight + 1 + accountHeight + balanceHeight + rowSpacing * 6))
        
        initSubview()
    }
    
    private func initSubview() {
        self.backgroundColor = UIColor.white
        
        alertIcon = UIImageView()
        alertIcon.image = UIImage(named: "userID")
        
        alertTitle = UILabel()
        alertTitle.text = "充值金额不可提现，只能用于购彩，中奖后奖金可以提现"
        alertTitle.font = Font13
        alertTitle.textColor = UIColor.black
        alertTitle.numberOfLines = 2
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.gray
        
        account = UILabel()
        account.text = "当前账号: 114548655425365"
        account.font = Font13
        account.textColor = UIColor.black
        
        balance = UILabel()
        balance.text = "当前余额: 8888888元"
        balance.font = Font13
        balance.textColor = UIColor.black
        
        self.addSubview(alertIcon)
        self.addSubview(alertTitle)
        self.addSubview(lineView)
        self.addSubview(account)
        self.addSubview(balance)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        alertIcon.snp.makeConstraints { (make) in
            make.height.equalTo(iconHeight)
            make.width.equalTo(iconHeight)
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(20)
        }
        alertTitle.snp.makeConstraints { (make) in
            make.height.equalTo(titleHeight)
            make.left.equalTo(alertIcon.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(20)
        }
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.right.equalTo(self)
            make.top.equalTo(alertTitle.snp.bottom).offset(10)
        }
        account.snp.makeConstraints { (make) in
            make.height.equalTo(accountHeight)
            make.left.equalTo(self).offset(10)
            make.top.equalTo(lineView.snp.bottom).offset(10)
        }
        balance.snp.makeConstraints { (make) in
            make.height.equalTo(balanceHeight)
            make.left.right.equalTo(account)
            make.top.equalTo(account.snp.bottom).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
