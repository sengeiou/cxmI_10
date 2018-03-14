//
//  WithdrawalViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class WithdrawalViewController: BaseViewController {

    //MARK: - 点击事件
    // 提交
    @objc private func drawMoney(_ sender: UIButton) {
        
    }
    // 全部提现
    @objc private func allDraw(_ sender: UIButton) {
        amountOfMoney.text = "888"
    }
    // 管理
    @objc private func administrate(_ sender: UIButton) {
        print("管理银行卡")
        let bankCard = BankCardViewController()
        pushViewController(vc: bankCard)
    }
    //MARK: - 属性
    private var moneyLB : UILabel! // 可提现金额
    private var bankCardBGView : UIView! // 银行卡背景图
    private var bankCardLB : UILabel! // 银行卡
    private var bankCardBut : UIButton! // 银行卡管理
    private var amountOfMoney : UITextField!// 提现金额
    private var allDrawBut : UIButton!  // 全部提现
    private var drawMoneyBut : UIButton! //提交按钮
    private var instructions : UILabel! // 说明
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        initSubview()
    }
    //MARK: - 网络请求
    private func drawRequest(money: String) {
        
    }
    //MARK: - UI
    private func initSubview() {
        moneyLB = UILabel()
        moneyLB.font = Font14
        moneyLB.text = "可提现金额: 100元"
        moneyLB.textColor = UIColor.black
        moneyLB.textAlignment = .left
        
        bankCardBGView = UIView()
        bankCardBGView.backgroundColor = UIColor.gray
        
        bankCardLB = UILabel()
        bankCardLB.font = Font12
        bankCardLB.text = "银行卡: 请添加银行卡"
        bankCardLB.textColor = UIColor.black
        bankCardLB.textAlignment = .left
        
        bankCardBut = UIButton(type: .custom)
        bankCardBut.setTitle("管理", for: .normal)
        bankCardBut.setTitleColor(UIColor.black, for: .normal)
        bankCardBut.contentHorizontalAlignment = .right
        bankCardBut.addTarget(self, action: #selector(administrate(_:)), for: .touchUpInside)
        
        allDrawBut = UIButton(type: .custom)
        allDrawBut.setTitle("全部提现", for: .normal)
        allDrawBut.setTitleColor(UIColor.black, for: .normal)
        allDrawBut.addTarget(self, action: #selector(allDraw(_:)), for: .touchUpInside)
        allDrawBut.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        
        amountOfMoney = UITextField()
        amountOfMoney.font = Font12
        amountOfMoney.placeholder = "请输入提现金额"
        amountOfMoney.borderStyle = .roundedRect
        amountOfMoney.rightView = allDrawBut
        amountOfMoney.rightViewMode = .always
        amountOfMoney.keyboardType = .numberPad
        
        drawMoneyBut = UIButton(type: .custom)
        drawMoneyBut.setTitle("提交", for: .normal)
        drawMoneyBut.setTitleColor(UIColor.black, for: .normal)
        drawMoneyBut.backgroundColor = UIColor.brown
        drawMoneyBut.layer.cornerRadius = 5
        drawMoneyBut.addTarget(self, action: #selector(drawMoney(_:)), for: .touchUpInside)
        
        instructions = UILabel()
        instructions.font = Font12
        instructions.numberOfLines = 6
        instructions.text = """
        说明：
        1.中奖金额在1小时后可提现；
        2.提现不收手续费；
        3.为防止洗钱等不法行为，充值金额只能用于消费或退款；
        4.每天提现不超过3次，每次最低3元；
        5.活动赠送金额不可提现；
        """
        instructions.textColor = UIColor.black
        
        self.view.addSubview(moneyLB)
        self.view.addSubview(bankCardBGView)
        bankCardBGView.addSubview(bankCardLB)
        bankCardBGView.addSubview(bankCardBut)
        self.view.addSubview(amountOfMoney)
        self.view.addSubview(drawMoneyBut)
        self.view.addSubview(instructions)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        moneyLB.snp.makeConstraints { (make) in
            make.height.equalTo(labelHeight)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight + 20)
        }
        bankCardBGView.snp.makeConstraints { (make) in
            make.height.equalTo(textFieldHeight)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(moneyLB.snp.bottom).offset(verticalSpacing)
        }
        bankCardLB.snp.makeConstraints { (make) in
            make.left.equalTo(bankCardBGView).offset(1)
            make.right.equalTo(bankCardBGView).offset(-1)
            make.top.equalTo(bankCardBGView).offset(1)
            make.bottom.equalTo(bankCardBGView).offset(-1)
        }
        bankCardBut.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.right.equalTo(bankCardBGView).offset(-1)
            make.top.equalTo(bankCardBGView).offset(5)
            make.bottom.equalTo(bankCardBGView).offset(-5)
        }
        amountOfMoney.snp.makeConstraints { (make) in
            make.height.equalTo(textFieldHeight)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(bankCardBGView.snp.bottom).offset(1)
        }
        drawMoneyBut.snp.makeConstraints { (make) in
            make.height.equalTo(buttonHeight)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(amountOfMoney.snp.bottom).offset(100)
        }
        instructions.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(drawMoneyBut.snp.bottom).offset(50)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
