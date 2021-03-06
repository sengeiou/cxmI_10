//
//  NewsHeaderView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let iconHeight : CGFloat = 56

protocol NewsHeaderViewDelegate {
    func didTipNewsUserIcon() -> Void
    func didTipNewsLogin() -> Void
}

class NewsHeaderView: UIView, UserInfoPro {
    
    
    
    //MARK: - 设置界面显示信息
    public var userInfo : UserInfoDataModel! {
        didSet{
            guard userInfo != nil else { return }
            self.phoneLB.text = userInfo.mobile
            
            loginButton.isHidden = true
            //            let url = URL(string: userInfo.headimg)
            //            self.icon.kf.setImage(with: url)
            
//            self.accountBalanceLB.attributedText = getBalanceText(str: userInfo.totalMoney)
//            self.withdrawalBalanceLB.attributedText = getBalanceText(str: userInfo.userMoney)
            
            //setupAuth()
        }
    }
    
    public func changeHeaderStatusWithLogin() {
        loginButton.isHidden = false
        phoneLB.text = ""
        self.userInfo = nil
    }
    
    public func setIcon(image: UIImage) {
        icon.image = image
    }
    
    @objc private func userIconClick() {
        guard delegate != nil else { return }
        delegate.didTipNewsUserIcon()
    }
    
    private func getBalanceText(str : String?) -> NSAttributedString {
        
        var attStr : NSMutableAttributedString!
        
        if str != nil , str != "" {
            attStr = NSMutableAttributedString(string: str!)
        }else {
            attStr = NSMutableAttributedString(string: "0.00")
        }
        
        let 元 = NSAttributedString(string: "元", attributes: [NSAttributedString.Key.font: Font14])
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
    
    
    // MARK: - 属性
    public var delegate : NewsHeaderViewDelegate!
    
    private var icon : UIImageView! // 用户头像
    private var phoneLB : UILabel! // 手机号
    lazy private var loginButton : UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = Font14
        button.setTitle("未登录", for: .normal)
        button.setTitleColor(Color505050, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(loginClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc private func loginClicked(_ sender: UIButton ) {
        guard delegate != nil else { return }
        delegate.didTipNewsLogin()
    }
    
    //private var accountTitle : UILabel! // 账户标题
    //private var withdrawalTitle : UILabel! // 可提现标题
    //private var accountBalanceLB : UILabel! // 账户余额
    //private var withdrawalBalanceLB : UILabel! // 可提现余额
    
    //private var rechargeBut : UIButton! // 充值按钮
    //private var withdrawalBut : UIButton! // 提现按钮
    
    private var hLine : UIView! // 水平分割线
    private var vLine : UIView! // 竖直分割线
    
    // 生命周期
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 83))
        self.backgroundColor = UIColor.white
        initSubview()
    }
    
    // MARK: - 懒加载
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
        
//        let stateView = UIButton(type: .custom)
//        stateView.titleLabel?.font = Font11
//        stateView.setTitle("您还未实名认证，尽快实名认证", for: .normal)
//        stateView.setTitleColor(ColorE95504, for: .normal)
//        stateView.contentHorizontalAlignment = .left
//        stateView.addTarget(self, action: #selector(alertClicked(_:)), for: .touchUpInside)
        
        bgView.addSubview(imagev)
       // bgView.addSubview(stateView)
        bgView.addSubview(imageview)
        
        imagev.snp.makeConstraints({ (make) in
            make.top.equalTo(bgView).offset(4)
            make.bottom.equalTo(bgView).offset(-4)
            make.left.equalTo(bgView).offset(10)
            make.width.equalTo(imagev.snp.height)
        })
//        stateView.snp.makeConstraints({ (make) in
//            make.top.equalTo(bgView)
//            make.bottom.equalTo(bgView)
//            make.left.equalTo(imagev.snp.right).offset(5)
//            make.right.equalTo(imageview.snp.left).offset(-1)
//        })
        
        imageview.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(bgView).offset(4)
            make.bottom.equalTo(bgView).offset(-4)
            make.width.equalTo(imageview.snp.height)
            make.right.equalTo(bgView).offset(-7.5)
        })
        
        return bgView
    }() // 未认证提示条
    
    // MARK: - LAYOUT
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
        
//        accountBalanceLB.snp.makeConstraints { (make) in
//            make.top.equalTo(icon.snp.bottom).offset(5)
//            make.left.equalTo(self)
//            make.right.equalTo(withdrawalBalanceLB.snp.left).offset(1)
//            make.height.equalTo(20)
//        }
//        withdrawalBalanceLB.snp.makeConstraints { (make) in
//            make.top.height.equalTo(accountBalanceLB)
//            make.right.equalTo(self)
//            make.width.equalTo(accountBalanceLB)
//        }
//        accountTitle.snp.makeConstraints { (make) in
//            make.top.equalTo(accountBalanceLB.snp.bottom).offset(1)
//            make.left.height.equalTo(accountBalanceLB)
//
//        }
//        withdrawalTitle.snp.makeConstraints { (make) in
//            make.top.height.equalTo(accountTitle)
//            make.right.equalTo(self)
//            make.left.equalTo(accountTitle.snp.right).offset(1)
//            make.width.equalTo(accountTitle)
//        }
        
//        hLine.snp.makeConstraints { (make) in
//            make.top.equalTo(accountTitle.snp.bottom).offset(15)
//            make.left.right.equalTo(self)
//            make.height.equalTo(SeparationLineHeight)
//        }
//        vLine.snp.makeConstraints { (make) in
//            make.top.equalTo(hLine.snp.bottom)
//            make.bottom.equalTo(self)
//            make.left.equalTo(rechargeBut.snp.right)
//            make.width.equalTo(SeparationLineHeight)
//        }
//        rechargeBut.snp.makeConstraints { (make) in
//            make.top.equalTo(hLine.snp.bottom).offset(1)
//            make.left.equalTo(self)
//            make.width.equalTo(withdrawalBut)
//            make.bottom.equalTo(self).offset(-1)
//        }
        
//        withdrawalBut.snp.makeConstraints { (make) in
//            make.top.equalTo(rechargeBut)
//            make.left.equalTo(vLine.snp.right)
//            make.right.equalTo(self)
//            make.height.equalTo(rechargeBut)
//            make.width.equalTo(rechargeBut)
//        }
        
    }
    
    private func initSubview() {
        // 头像
        icon = UIImageView()
        icon.layer.cornerRadius = iconHeight / 2
        icon.layer.masksToBounds = true
        
        if let imageData = UserDefaults.standard.data(forKey: UserIconData) {
            if let image = UIImage(data: imageData) {
                icon.image = image
            }
        }else {
            icon.image = UIImage(named: "head")
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userIconClick))
        
        icon.addGestureRecognizer(tap)
        icon.isUserInteractionEnabled = true
        
        // 手机号
        phoneLB = UILabel()
        phoneLB.font = Font16
        phoneLB.tintColor = Color505050
        if let userInfo = getUserData() {
            if userInfo.mobile != nil {
                phoneLB.text = userInfo.mobile
            }
        }
        //        var phoneNum = "18500237152"
        //
        //        phoneNum.replaceSubrange(phoneNum.index(phoneNum.startIndex, offsetBy: 3)...phoneNum.index(phoneNum.startIndex, offsetBy: 6), with: "****")
        //        phoneLB.text = phoneNum
        
        // 账户标题
//        accountTitle = UILabel()
//        accountTitle.font = Font12
//        accountTitle.text = "账户余额"
//        accountTitle.textColor = ColorA0A0A0
//        accountTitle.textAlignment = .center
        
        // 可提现标题
//        withdrawalTitle = UILabel()
//        withdrawalTitle.font = Font12
//        withdrawalTitle.text = "可提现余额"
//        withdrawalTitle.textColor = ColorA0A0A0
//        withdrawalTitle.textAlignment = .center
//
//        // 账户余额
//        accountBalanceLB = UILabel()
//        accountBalanceLB.font = Font21
//        //accountBalanceLB.text = "888元"
//        accountBalanceLB.textAlignment = .center
//        accountBalanceLB.textColor = ColorE95504
//
//        // 可提现余额
//        withdrawalBalanceLB = UILabel()
//        withdrawalBalanceLB.font = Font21
//        //withdrawalBalanceLB.text = "88元"
//        withdrawalBalanceLB.textAlignment = .center
//        withdrawalBalanceLB.textColor = ColorE95504
        
        hLine = UIView()
        hLine.backgroundColor = ColorF4F4F4
        
        vLine = UIView()
        vLine.backgroundColor = ColorF4F4F4
        
        // 充值
//        rechargeBut = UIButton(type: .custom)
//        rechargeBut.titleLabel?.font = Font14
//        rechargeBut.setTitle("充值", for: .normal)
//        rechargeBut.setTitleColor(ColorF7931E, for: .normal)
//        rechargeBut.addTarget(self, action: #selector(rechargeClicked(_:)), for: .touchUpInside)
//
//        // 提现
//        withdrawalBut = UIButton(type: .custom)
//        withdrawalBut.titleLabel?.font = Font14
//        withdrawalBut.setTitle("提现", for: .normal)
//        withdrawalBut.setTitleColor(ColorF7931E, for: .normal)
//        withdrawalBut.addTarget(self, action: #selector(withdrawalClicked(_:)), for: .touchUpInside)
        
        self.addSubview(icon)
        self.addSubview(phoneLB)
//        self.addSubview(accountTitle)
//        self.addSubview(withdrawalTitle)
//        self.addSubview(accountBalanceLB)
//        self.addSubview(withdrawalBalanceLB)
        self.addSubview(hLine)
        self.addSubview(vLine)
//        self.addSubview(rechargeBut)
//        self.addSubview(withdrawalBut)
        
        if let userInfo = getUserData() {
            if userInfo.mobile != nil {
                phoneLB.text = userInfo.mobile
            }
            loginButton.isHidden = true
        }else {
            self.addSubview(loginButton)
            loginButton.isHidden = false
            loginButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(icon.snp.centerY)
                make.left.equalTo(icon.snp.right).offset(20)
                make.width.equalTo(80)
                make.height.equalTo(20)
            }
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
