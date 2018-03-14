//
//  ForgetPswVCodeVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class ForgetPswVCodeVC: BaseViewController, CountdownButtonDelegate, UITextFieldDelegate, ValidatePro {
    
    //MARK: - 点击事件
    @objc private func confirmButClicked(_ sender: UIButton) {
        guard validate(.password, str: self.passwordTF.text) == true else {
            showHUD(message: "请输入6-20位的密码")
            return }
        guard validate(.vcode, str: self.vcodeTF.text) else {
            showHUD(message: "请输入验证码")
            return }
        
        updatePassRequest()
    }
    
    func countdownButClicked(button: CountdownButton) {
        guard validate(.password, str: self.passwordTF.text) == true else {
            showHUD(message: "请输入6-20位的密码")
            return }
        sendSmsRequest()
    }
    
    //MARK: - 属性
    public var phoneNum : String!
    
    private var passwordTF : CustomTextField!
    private var vcodeTF : CustomTextField!
    
    private var confirm : UIButton!
    
    private var countdownBut : CountdownButton!
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘·登录"
        creatUI() //创建UI
    }

    //MARK: - 网络请求
    private func updatePassRequest() {
        _ = loginProvider.rx.request(.updatePass(mobile: self.phoneNum, password: self.passwordTF.text!))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe({ (event) in
                switch event {
                case .next(let data):
                    switch data.code {
                    case "0":
                        break
                    default: break
                }
                case .error(let error):
                    guard let hxError = error as? HXError else { return }
                    switch hxError {
                    case .UnexpectedResult(_, let resultMsg):
                        self.showConfirm(message: resultMsg!, confirm: { (action) in
                            
                        })
                    default : break
                    }
                case .completed : break
                }
            })
    }
    
    private func sendSmsRequest() {
        _ = loginProvider.rx.request(.sendSms(mobile: self.phoneNum, smsType: "1"))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe { (event) in
                switch event {
                case .next(let data):
                    switch data.code {
                    case "0" :
                        break
                    default : break
                    }
                case .error(let error):
                    guard let hxError = error as? HXError else { return }
                    switch hxError {
                    case .UnexpectedResult(_, let resultMsg):
                        self.showConfirm(message: resultMsg!, confirm: { (action) in
                            self.popViewController()
                        })
                    default : break
                    }
                case .completed : break
                }
        }
    }
    
    //MARK: - UI
    private func creatUI() {
        
        passwordTF = CustomTextField(imageName: "userID")
        passwordTF.delegate = self
        passwordTF.placeholder = "请输入您的新密码6-20个字符"
        passwordTF.borderStyle = .roundedRect
        
        vcodeTF = CustomTextField(imageName: "userID")
        vcodeTF.placeholder = "请输入验证码"
        vcodeTF.borderStyle = .roundedRect
        
        countdownBut = CountdownButton()
        countdownBut.delegate = self
        countdownBut.layer.cornerRadius = 5
        countdownBut.isCounting = true
        
        confirm = UIButton(type: .custom)
        confirm.setTitle("确认", for: .normal)
        confirm.setTitleColor(UIColor.white, for: .normal)
        confirm.backgroundColor = UIColor.blue
        confirm.layer.cornerRadius = 5
        confirm.addTarget(self, action: #selector(confirmButClicked(_:)), for: .touchUpInside)
        
        
        self.view.addSubview(passwordTF)
        self.view.addSubview(vcodeTF)
        //self.view.addSubview(countdownBut)
        self.view.addSubview(confirm)
        vcodeTF.addSubview(countdownBut)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        passwordTF.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(SafeAreaTopHeight + 20)
        }
        vcodeTF.snp.makeConstraints { (make) in
            make.height.left.right.equalTo(passwordTF)
            make.top.equalTo(passwordTF.snp.bottom).offset(20)
        }
        countdownBut.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.right.equalTo(vcodeTF).offset(-1)
            make.top.equalTo(vcodeTF).offset(1)
            make.bottom.equalTo(vcodeTF).offset(-1)
        }
        confirm.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(countdownBut.snp.bottom).offset(20)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
