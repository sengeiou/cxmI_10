//
//  MeHeaderView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import Kingfisher


protocol MeHeaderViewDelegate {
    func rechargeClicked() -> Void
    func withdrawalClicked() -> Void
    func alertClicked() -> Void
}

class MeHeaderView: UIView {

    // MARK: - 点击事件
    @objc private func rechargeClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.rechargeClicked()
    }
    
    @objc private func withdrawalClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.withdrawalClicked()
    }
    @objc private func alertClicked(_ sender: UIButton) {
        guard delegate != nil else { return }
        delegate.alertClicked()
    }
    
    //MARK: - 设置界面显示信息
    public var userInfo : UserInfoDataModel! {
        didSet{
            self.phoneLB.text = userInfo.mobile
            let url = URL(string: userInfo.headimg)
            self.icon.kf.setImage(with: url)
            self.accountBalanceLB.text = userInfo.userMoney != nil ? userInfo.userMoney : "" + "元"
            self.withdrawalBalanceLB.text = userInfo.userMoney != nil ? userInfo.userMoney : "" + "元"
            
            setupAuth()
        }
    }
    
    private func setupAuth() {
        if userInfo.isReal {
            self.authenticationStateLB.text = "认证用户"
            notAuthenticationView.isHidden = true
            accountTitle.snp.makeConstraints { (make) in
                make.top.equalTo(icon.snp.bottom).offset(10)
            }
            self.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 200)
        }else {
            self.authenticationStateLB.text = "未认证"
        }
    }
    
    public var delegate : MeHeaderViewDelegate!
    
    private var icon : UIImageView! // 用户头像
    private var phoneLB : UILabel! // 手机号
    private var authenticationStateLB : UILabel! // 认证状态
    private var notAuthenticationView : UILabel!  // 未认证提示条
    private var accountTitle : UILabel! // 账户标题
    private var withdrawalTitle : UILabel! // 可提现标题
    private var accountBalanceLB : UILabel! // 账户余额
    private var withdrawalBalanceLB : UILabel! // 可提现余额
    
    private var rechargeBut : UIButton! // 充值按钮
    private var withdrawalBut : UIButton! // 提现按钮
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 230))
        self.backgroundColor = UIColor.white
        initSubview()
    }
    
    private func initSubview() {
        // 头像
        icon = UIImageView()
        icon.image = UIImage(named: "userID")
        
        // 手机号
        phoneLB = UILabel()
        phoneLB.font = Font12
        var phoneNum = "18500237152"
        
        phoneNum.replaceSubrange(phoneNum.index(phoneNum.startIndex, offsetBy: 3)...phoneNum.index(phoneNum.startIndex, offsetBy: 6), with: "****")
        phoneLB.text = phoneNum
        
        // 认证状态
        authenticationStateLB = UILabel()
        authenticationStateLB.font = Font12
        authenticationStateLB.text = "认证用户"
        authenticationStateLB.textAlignment = .right
        
        // 未认证提示条
        notAuthenticationView = UILabel()
        notAuthenticationView.font = Font12
        notAuthenticationView.backgroundColor = UIColor.red
        notAuthenticationView.text = "您还未实名认证，尽快实名认证"
        notAuthenticationView.textAlignment = .center
        // 手势
        let  tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MeHeaderView.alertClicked(_:)))
        notAuthenticationView.addGestureRecognizer(tapRecognizer)
        notAuthenticationView.isUserInteractionEnabled = true
        
        // 账户标题
        accountTitle = UILabel()
        accountTitle.font = Font12
        accountTitle.text = "账户余额"
        accountTitle.textAlignment = .center
        
        // 可提现标题
        withdrawalTitle = UILabel()
        withdrawalTitle.font = Font12
        withdrawalTitle.text = "可提现余额"
        withdrawalTitle.textAlignment = .center
        
        // 账户余额
        accountBalanceLB = UILabel()
        accountBalanceLB.font = Font12
        accountBalanceLB.text = "888元"
        accountBalanceLB.textAlignment = .center
        
        // 可提现余额
        withdrawalBalanceLB = UILabel()
        withdrawalBalanceLB.font = Font12
        withdrawalBalanceLB.text = "88元"
        withdrawalBalanceLB.textAlignment = .center
        
        // 充值
        rechargeBut = UIButton(type: .custom)
        rechargeBut.titleLabel?.font = Font12
        rechargeBut.setTitle("充值", for: .normal)
        rechargeBut.setTitleColor(UIColor.black, for: .normal)
        rechargeBut.addTarget(self, action: #selector(rechargeClicked(_:)), for: .touchUpInside)
        
        // 提现
        withdrawalBut = UIButton(type: .custom)
        withdrawalBut.titleLabel?.font = Font12
        withdrawalBut.setTitle("提现", for: .normal)
        withdrawalBut.setTitleColor(UIColor.black, for: .normal)
        withdrawalBut.addTarget(self, action: #selector(withdrawalClicked(_:)), for: .touchUpInside)
        
        self.addSubview(icon)
        self.addSubview(phoneLB)
        self.addSubview(authenticationStateLB)
        self.addSubview(notAuthenticationView)
        self.addSubview(accountTitle)
        self.addSubview(withdrawalTitle)
        self.addSubview(accountBalanceLB)
        self.addSubview(withdrawalBalanceLB)
        self.addSubview(rechargeBut)
        self.addSubview(withdrawalBut)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.snp.makeConstraints { (make) in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
        }
        phoneLB.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.top.equalTo(self).offset(20)
            make.left.equalTo(icon.snp.right).offset(10)
            make.right.equalTo(authenticationStateLB.snp.left).offset(-10)
        }
        authenticationStateLB.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(phoneLB)
            make.top.equalTo(phoneLB)
            make.right.equalTo(self).offset(-10)
        }
        notAuthenticationView.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.top.equalTo(icon.snp.bottom).offset(10)
            make.left.right.equalTo(self)
        }
        accountTitle.snp.makeConstraints { (make) in
            make.top.equalTo(notAuthenticationView.snp.bottom).offset(10)
            make.left.equalTo(self).offset(10)
            make.width.equalTo(withdrawalTitle)
            make.height.equalTo(30)
        }
        withdrawalTitle.snp.makeConstraints { (make) in
            make.top.height.equalTo(accountTitle)
            make.right.equalTo(self).offset(-10)
            make.left.equalTo(accountTitle.snp.right)
        }
        accountBalanceLB.snp.makeConstraints { (make) in
            make.top.equalTo(accountTitle.snp.bottom).offset(10)
            make.left.height.width.equalTo(accountTitle)
        }
        withdrawalBalanceLB.snp.makeConstraints { (make) in
            make.top.equalTo(accountBalanceLB)
            make.right.left.height.equalTo(withdrawalTitle)
        }
        rechargeBut.snp.makeConstraints { (make) in
            make.top.equalTo(accountBalanceLB.snp.bottom).offset(10)
            make.left.equalTo(self).offset(10)
            make.width.equalTo(withdrawalBut)
            make.height.equalTo(40)
        }
        withdrawalBut.snp.makeConstraints { (make) in
            make.top.equalTo(rechargeBut)
            make.left.equalTo(rechargeBut.snp.right)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(rechargeBut)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
