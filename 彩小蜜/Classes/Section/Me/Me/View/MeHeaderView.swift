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
//            let url = URL(string: userInfo.headimg)
//            self.icon.kf.setImage(with: url)
            
            self.accountBalanceLB.attributedText = getBalanceText(str: userInfo.userMoney )
            self.withdrawalBalanceLB.attributedText = getBalanceText(str: userInfo.userMoneyLimit)

            setupAuth()
        }
    }
    
    private func getBalanceText(str : String?) -> NSAttributedString {
    
        let attStr = NSMutableAttributedString(string: str != nil ? str! : "0.00")
        let 元 = NSAttributedString(string: "元", attributes: [NSAttributedStringKey.font: Font14])
        attStr.append(元)
        return attStr
    }
    
    private func setupAuth() {
        if userInfo.isReal {
            self.addSubview(authenticationView)
            
            authenticationView.snp.makeConstraints { (make) in
                make.width.equalTo(80)
                make.height.equalTo(18)
                make.top.equalTo(phoneLB.snp.bottom).offset(5)
                make.left.equalTo(phoneLB)
            }
            
        }else {
            self.addSubview(notAuthenticationView)
            notAuthenticationView.snp.makeConstraints { (make) in
                make.width.equalTo(226)
                make.height.equalTo(18)
                make.top.equalTo(phoneLB.snp.bottom).offset(5)
                make.left.equalTo(phoneLB)
            }
        }
    }

    
    
    public var delegate : MeHeaderViewDelegate!
    
    private var icon : UIImageView! // 用户头像
    private var phoneLB : UILabel! // 手机号
    
    private var accountTitle : UILabel! // 账户标题
    private var withdrawalTitle : UILabel! // 可提现标题
    private var accountBalanceLB : UILabel! // 账户余额
    private var withdrawalBalanceLB : UILabel! // 可提现余额
    
    private var rechargeBut : UIButton! // 充值按钮
    private var withdrawalBut : UIButton! // 提现按钮
    
    private var hLine : UIView! // 水平分割线
    private var vLine : UIView! // 竖直分割线
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 183))
        self.backgroundColor = UIColor.white
        initSubview()
    }
    
    lazy private var authenticationView : UIImageView = {
    
        let stateView = UIImageView()
        
        stateView.image = UIImage(named: "V")
        
        
        return stateView
    }() // 认证状态
    lazy private var notAuthenticationView : UIView = {
    
        let bgView = UIView()
        bgView.backgroundColor = ColorE95504a2
        bgView.layer.cornerRadius = 2
        
        let imagev = UIImageView()
        imagev.image = UIImage(named: "note")
        let imageview = UIImageView()
        imageview.image = UIImage(named: "redarrow")
        
        let stateView = UIButton(type: .custom)
        stateView.titleLabel?.font = Font11
        stateView.setTitle("您还未实名认证，尽快实名认证", for: .normal)
        stateView.setTitleColor(ColorE95504, for: .normal)
        stateView.contentHorizontalAlignment = .left
        stateView.addTarget(self, action: #selector(alertClicked(_:)), for: .touchUpInside)
        
        bgView.addSubview(imagev)
        bgView.addSubview(stateView)
        bgView.addSubview(imageview)
        
        imagev.snp.makeConstraints({ (make) in
            make.top.equalTo(bgView).offset(2)
            make.bottom.equalTo(bgView).offset(-2)
            make.left.equalTo(bgView).offset(10)
            make.width.equalTo(imagev.snp.height)
        })
        stateView.snp.makeConstraints({ (make) in
            make.top.equalTo(bgView)
            make.bottom.equalTo(bgView)
            make.left.equalTo(imagev.snp.right).offset(5)
            make.right.equalTo(imageview.snp.left).offset(-1)
        })
        
        imageview.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(bgView).offset(2)
            make.bottom.equalTo(bgView).offset(-2)
            make.width.equalTo(imageview.snp.height)
            make.right.equalTo(bgView).offset(-7.5)
        })
        
        return bgView
    }() // 未认证提示条
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.snp.makeConstraints { (make) in
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self).offset(23.5)
        }
        phoneLB.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.top.equalTo(self).offset(24.5)
            make.left.equalTo(icon.snp.right).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        
        accountBalanceLB.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(5)
            make.left.equalTo(self)
            make.right.equalTo(withdrawalBalanceLB.snp.left).offset(1)
            make.height.equalTo(20)
        }
        withdrawalBalanceLB.snp.makeConstraints { (make) in
            make.top.height.equalTo(accountBalanceLB)
            make.right.equalTo(self)
            make.width.equalTo(accountBalanceLB)
        }
        accountTitle.snp.makeConstraints { (make) in
            make.top.equalTo(accountBalanceLB.snp.bottom).offset(1)
            make.left.height.equalTo(accountBalanceLB)
            
        }
        withdrawalTitle.snp.makeConstraints { (make) in
            make.top.height.equalTo(accountTitle)
            make.right.equalTo(self)
            make.left.equalTo(accountTitle.snp.right).offset(1)
            make.width.equalTo(accountTitle)
        }
        
        hLine.snp.makeConstraints { (make) in
            make.top.equalTo(accountTitle.snp.bottom).offset(15)
            make.left.right.equalTo(self)
            make.height.equalTo(SeparationLineHeight)
        }
        vLine.snp.makeConstraints { (make) in
            make.top.equalTo(hLine.snp.bottom)
            make.bottom.equalTo(self)
            make.left.equalTo(rechargeBut.snp.right)
            make.width.equalTo(SeparationLineHeight)
        }
        rechargeBut.snp.makeConstraints { (make) in
            make.top.equalTo(hLine.snp.bottom).offset(1)
            make.left.equalTo(self)
            make.width.equalTo(withdrawalBut)
            make.bottom.equalTo(self).offset(-1)
        }
        
        withdrawalBut.snp.makeConstraints { (make) in
            make.top.equalTo(rechargeBut)
            make.left.equalTo(vLine.snp.right)
            make.right.equalTo(self)
            make.height.equalTo(rechargeBut)
            make.width.equalTo(rechargeBut)
        }
        
    }
    
    private func initSubview() {
        // 头像
        icon = UIImageView()
        icon.image = UIImage(named: "head")
        
        // 手机号
        phoneLB = UILabel()
        phoneLB.font = Font16
        phoneLB.tintColor = Color505050
        var phoneNum = "18500237152"
        
        phoneNum.replaceSubrange(phoneNum.index(phoneNum.startIndex, offsetBy: 3)...phoneNum.index(phoneNum.startIndex, offsetBy: 6), with: "****")
        phoneLB.text = phoneNum
        
        // 账户标题
        accountTitle = UILabel()
        accountTitle.font = Font12
        accountTitle.text = "账户余额"
        accountTitle.textColor = ColorA0A0A0
        accountTitle.textAlignment = .center
        
        // 可提现标题
        withdrawalTitle = UILabel()
        withdrawalTitle.font = Font12
        withdrawalTitle.text = "可提现余额"
        withdrawalTitle.textColor = ColorA0A0A0
        withdrawalTitle.textAlignment = .center
        
        // 账户余额
        accountBalanceLB = UILabel()
        accountBalanceLB.font = Font21
        accountBalanceLB.text = "888元"
        accountBalanceLB.textAlignment = .center
        accountBalanceLB.textColor = ColorE95504
        
        // 可提现余额
        withdrawalBalanceLB = UILabel()
        withdrawalBalanceLB.font = Font21
        withdrawalBalanceLB.text = "88元"
        withdrawalBalanceLB.textAlignment = .center
        withdrawalBalanceLB.textColor = ColorE95504
        
        hLine = UIView()
        hLine.backgroundColor = ColorF4F4F4
        
        vLine = UIView()
        vLine.backgroundColor = ColorF4F4F4
        
        // 充值
        rechargeBut = UIButton(type: .custom)
        rechargeBut.titleLabel?.font = Font14
        rechargeBut.setTitle("充值", for: .normal)
        rechargeBut.setTitleColor(ColorF7931E, for: .normal)
        rechargeBut.addTarget(self, action: #selector(rechargeClicked(_:)), for: .touchUpInside)
        
        // 提现
        withdrawalBut = UIButton(type: .custom)
        withdrawalBut.titleLabel?.font = Font14
        withdrawalBut.setTitle("提现", for: .normal)
        withdrawalBut.setTitleColor(ColorF7931E, for: .normal)
        withdrawalBut.addTarget(self, action: #selector(withdrawalClicked(_:)), for: .touchUpInside)
        
        self.addSubview(icon)
        self.addSubview(phoneLB)
        self.addSubview(accountTitle)
        self.addSubview(withdrawalTitle)
        self.addSubview(accountBalanceLB)
        self.addSubview(withdrawalBalanceLB)
        self.addSubview(hLine)
        self.addSubview(vLine)
        self.addSubview(rechargeBut)
        self.addSubview(withdrawalBut)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
