//
//  WithdrawalViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class WithdrawalViewController: BaseViewController, ValidatePro {

    //MARK: - 点击事件
    // 提交   确认支付
    @objc private func drawMoney(_ sender: UIButton) {
        guard canWithDraw else { return }
        guard drawDataModel != nil else { return }
        guard drawDataModel.defaultBankLabel != nil, drawDataModel.defaultBankLabel != "" else {
            showHUD(message: "请添加收款银行卡")
            return
        }
        
        guard let draw = amountOfMoney.text else {
            showHUD(message: "请输入提现金额")
            return }
        
        guard let drawAmount = Double(draw) else { return }
        guard let amount = Double(drawDataModel.userMoney) else { return }
        guard drawAmount <= amount else {
            showHUD(message: "您输入的金额已超过可提现金额")
            return
        }
        
        guard validate(.money, str: self.amountOfMoney.text) else {
            showHUD(message: "请输入正确的金额")
            return
        }
        self.canWithDraw = false
        drawRequest()
    }
    // 全部提现
    @objc private func allDraw(_ sender: UIButton) {
        guard drawDataModel != nil else { return }
        amountOfMoney.text = drawDataModel.userMoney
    }
    // 管理
    @objc private func administrate(_ sender: UIButton) {
        print("管理银行卡")
        let bankCard = BankCardViewController()
        pushViewController(vc: bankCard)
    }
    //MARK: - 属性
    private var bgView: UIView! // 背景图
    private var canWithDraw : Bool = true
    private var moneyLB : UILabel! // 可提现金额
    private var bankCardLB : UILabel! // 银行卡
    private var bankCardBut : UIButton! // 银行卡管理
    private var amountOfMoney : UITextField!// 提现金额
    private var allDrawBut : UIButton!  // 全部提现
    private var drawMoneyBut : UIButton! //提交按钮
    private var instructions : UITextView! // 说明
    private var bankTitle : UILabel!
    
    private var hLine : UIView!
    private var vLine : UIView!
    
    private var drawDataModel : WithDrawDataModel!
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 提现"
        initSubview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drawDataRequest()
    }
    //MARK: - 网络请求
    //提现
    private func drawRequest() {
        self.showProgressHUD()
        weak var weakSelf = self
        guard amountOfMoney != nil else { return }
        guard drawDataModel != nil else { return }
        guard let money = amountOfMoney.text else { return }
        _ = paymentProvider.rx.request(.paymentWithdraw(totalAmount: money, userBankId: drawDataModel.userBankId))
            .asObservable()
            .mapBaseObject(type: DataModel.self )
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                self.canWithDraw = true
                if let code = Int(data.code) {
                    switch code {
                    case 0:
                        self.dismissProgressHud()
                        self.showHUD(message: data.msg)
                        self.drawDataRequest()
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message:  data.msg)
                    }
                }
                
            }, onError: { (error) in
                self.canWithDraw = true
                self.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 0:
                        self.dismissProgressHud()
                        self.showHUD(message: msg!)
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    
                    if 300000...310000 ~= code {
                        print(code)
                        self.showHUD(message: msg!)
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    //提现信息
    private func drawDataRequest() {
        self.showProgressHUD()
        weak var weakSelf = self
        _ = userProvider.rx.request(.withDrawDataShow)
            .asObservable()
            .mapObject(type: WithDrawDataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                weakSelf?.drawDataModel = data
                weakSelf?.setDrawData(data: data)
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
    }
    
//    private func userInfoRequest() {
//        weak var weakSelf = self
//        _ = userProvider.rx.request(.userInfo)
//            .asObservable()
//            .mapObject(type: UserInfoDataModel.self)
//            .subscribe(onNext: { (data) in
//                guard weakSelf != nil else { return }
//                weakSelf!.userInfo = data
//                weakSelf?.tableview.reloadData()
//            }, onError: { (error) in
//                print(error)
//                guard let err = error as? HXError else { return }
//                switch err {
//                case .UnexpectedResult(let code, let msg):
//                    switch code {
//                    case 600:
//                        weakSelf?.removeUserData()
//                        let login = LoginViewController()
//                        weakSelf?.pushViewController(vc: login)
//                    default : break
//                    }
//
//                    if 300000...310000 ~= code {
//                        print(code)
//                        self.showHUD(message: msg!)
//                    }
//
//                default: break
//                }
//            }, onCompleted: nil, onDisposed: nil)
//    }
    
    private func setDrawData(data : WithDrawDataModel) {
        moneyLB.text = "可提现金额: \(data.userMoney!)元"
        
        guard let defaultBank = data.defaultBankLabel , data.defaultBankLabel != "" else {
            bankCardLB.text = "请添加银行卡"
            return
        }
        bankCardLB.text = defaultBank
    }
    
    //MARK: - UI
    private func initSubview() {
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        vLine = UIView()
        vLine.backgroundColor = ColorF4F4F4
        
        hLine = UIView()
        hLine.backgroundColor = ColorF4F4F4
        
        moneyLB = UILabel()
        moneyLB.font = Font15
        //moneyLB.text = "可提现金额: 100元"
        moneyLB.textColor = Color505050
        moneyLB.textAlignment = .left
        
        bankTitle = UILabel()
        bankTitle.font = Font15
        bankTitle.text = "银行卡: "
        bankTitle.textAlignment = .left
        bankTitle.textColor = ColorA0A0A0
        
        bankCardLB = UILabel()
        bankCardLB.font = Font15
        bankCardLB.textColor = Color505050
        bankCardLB.textAlignment = .left
        
        bankCardBut = UIButton(type: .custom)
        bankCardBut.setTitle("管理", for: .normal)
        bankCardBut.titleLabel?.font = Font15
        bankCardBut.setImage(UIImage(named: "jump"), for: .normal)
        bankCardBut.imageEdgeInsets = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
        bankCardBut.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        bankCardBut.setTitleColor(ColorA0A0A0, for: .normal)
        bankCardBut.contentHorizontalAlignment = .right
        bankCardBut.addTarget(self, action: #selector(administrate(_:)), for: .touchUpInside)
        
        allDrawBut = UIButton(type: .custom)
        allDrawBut.titleLabel?.font = Font15
        allDrawBut.setTitle("全部提现", for: .normal)
        allDrawBut.setTitleColor(ColorA0A0A0, for: .normal)
        allDrawBut.addTarget(self, action: #selector(allDraw(_:)), for: .touchUpInside)
        allDrawBut.frame = CGRect(x: 0, y: 0, width: 80, height: defaultCellHeight)
        
        
        allDrawBut.addSubview(vLine)
        
        amountOfMoney = UITextField()
        amountOfMoney.font = Font15
        amountOfMoney.placeholder = "请输入提现金额"
        amountOfMoney.rightView = allDrawBut
        amountOfMoney.rightViewMode = .always
        amountOfMoney.keyboardType = .numbersAndPunctuation
        
        drawMoneyBut = UIButton(type: .custom)
        drawMoneyBut.setTitle("立即提现", for: .normal)
        drawMoneyBut.setTitleColor(ColorFFFFFF, for: .normal)
        drawMoneyBut.backgroundColor = ColorEA5504
        drawMoneyBut.layer.cornerRadius = 5
        drawMoneyBut.addTarget(self, action: #selector(drawMoney(_:)), for: .touchUpInside)
        
        instructions = UITextView()
        instructions.isUserInteractionEnabled = false
        instructions.textColor = ColorA0A0A0
        instructions.font = Font13
        instructions.backgroundColor = UIColor.clear
        instructions.text = """
        说明：
        1.中奖金额在1小时后可提现；
        2.提现金额最低3元，每天提现不超过3次；
        3.提现暂不收取手续费；
        4.为防止恶意提款、洗钱等不法行为，充值金额及活动赠送金额只能用于消费，不可提现；
        """
        
        bgView.addSubview(moneyLB)
        bgView.addSubview(bankCardLB)
        bgView.addSubview(bankCardBut)
        bgView.addSubview(amountOfMoney)
        self.view.addSubview(drawMoneyBut)
        self.view.addSubview(instructions)
        bgView.addSubview(hLine)
        bgView.addSubview(bankTitle)
        self.view.addSubview(bgView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo(WithdrawalViewHeight)
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight)
        }
        
        hLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalTo(bgView).offset(-56)
            make.left.equalTo(bgView).offset(10)
            make.right.equalTo(bgView).offset(-10)
        }
        vLine.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.right.equalTo(allDrawBut.snp.left).offset(-15)
            make.top.equalTo(allDrawBut).offset(12)
            make.bottom.equalTo(allDrawBut).offset(-12)
        }
        
        moneyLB.snp.makeConstraints { (make) in
            make.height.equalTo(defaultCellHeight)
            make.left.equalTo(bgView).offset(leftSpacing)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.top.equalTo(bgView).offset(0)
        }
        
        bankTitle.snp.makeConstraints { (make) in
            make.height.equalTo(defaultCellHeight)
            make.left.equalTo(bgView).offset(leftSpacing)
            make.width.equalTo(55)
            make.bottom.equalTo(hLine.snp.top)
        }
        
        bankCardLB.snp.makeConstraints { (make) in
            make.height.equalTo(defaultCellHeight)
            make.left.equalTo(bankTitle.snp.right).offset(0)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.bottom.equalTo(hLine.snp.top).offset(0)
        }
        bankCardBut.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.height.bottom.equalTo(bankCardLB)
        }
        amountOfMoney.snp.makeConstraints { (make) in
            make.height.equalTo(defaultCellHeight)
            make.left.equalTo(bgView).offset(leftSpacing)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.bottom.equalTo(bgView).offset(0)
        }
        drawMoneyBut.snp.makeConstraints { (make) in
            make.height.equalTo(buttonHeight)
            make.left.equalTo(bgView).offset(leftSpacing)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.top.equalTo(amountOfMoney.snp.bottom).offset(loginButTopSpacing)
        }
        instructions.snp.makeConstraints { (make) in
            make.height.equalTo(300)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(drawMoneyBut.snp.bottom).offset(loginButHeight)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.amountOfMoney.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
