//
//  RegisterViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController, CountdownButtonDelegate, UITextFieldDelegate, ValidatePro, UserInfoPro {


    // MARK: - 点击事件
    @objc private func registerClicked(_ sender: UIButton) {
        
        guard validate(.phone, str: self.phoneTF.text) else {
            showHUD(message: "请输入手机号")
            return
        }
        guard validate(.password, str: self.passwordTF.text) else{
            showHUD(message: "请输入密码")
            return
        }
        guard self.vcodeTF.text != nil else {
            showHUD(message: "请输入验证码")
            return
        }
        
        registerRequest()
    }
    
    func countdownButClicked(button: CountdownButton) {
        guard validate(.phone, str: self.phoneTF.text) else {
            showHUD(message: "请输入合法的手机号")
            return
        }
        sendSmsRequest()
        
    }
    
    // MARK: - 属性
    private var phoneTF : CustomTextField!     // 输入手机号
    private var passwordTF : CustomTextField!  // 输入密码
    private var vcodeTF : UITextField!         // 输入验证码
    private var countdownBut : CountdownButton!// 倒计时按钮
    private var registerBut : UIButton!        // 注册按钮
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘·注册"
        initSubview()
    }

    // MARK: 网络请求
    private func registerRequest() {
        _ = loginProvider.rx.request(.register(mobile: self.phoneTF.text!, password: self.passwordTF.text!, vcode: vcodeTF.text!))
        .asObservable()
        .mapObject(type: UserDataModel.self)
        .subscribe { (event) in
            switch event {
            case .next(let data):
                print(data)
                self.save(userInfo: data)
                self.popToCurrentVC()
            case .error(let error):
                guard let hxError = error as? HXError else { return }
                switch hxError {
                case .UnexpectedResult(_, let resultMsg):
                    self.showConfirm(message: resultMsg!, confirm: { (action) in
                        self.popViewController()
                    })
                default : break
                }
            case .completed:
                break
            }
        }
    }
    
    private func sendSmsRequest() {
        _ = loginProvider.rx.request(.sendSms(mobile: self.phoneTF.text!, smsType: "1"))
        .asObservable()
        .mapBaseObject(type: DataModel.self)
            .subscribe { (event) in
                switch event {
                case .next(let data):
                    switch data.code {
                    case "22" :
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
    private func initSubview() {
        phoneTF = CustomTextField(imageName: "userID")
        phoneTF.delegate = self
        phoneTF.placeholder = "请输入手机号"
        phoneTF.borderStyle = .roundedRect
        phoneTF.keyboardType = .numberPad
        
        passwordTF = CustomTextField(imageName: "userID")
        passwordTF.delegate = self
        passwordTF.placeholder = "6-20位密码"
        passwordTF.borderStyle = .roundedRect
        passwordTF.isPassword = true 
        
        vcodeTF = UITextField()
        vcodeTF.delegate = self
        vcodeTF.placeholder = "输入短信验证码"
        vcodeTF.borderStyle = .roundedRect
        vcodeTF.keyboardType = .numberPad
        
        countdownBut = CountdownButton()
        countdownBut.delegate = self
        countdownBut.layer.cornerRadius = 5
        
        registerBut = UIButton(type: .custom)
        registerBut.setTitle("注册", for: .normal)
        registerBut.setTitleColor(UIColor.black, for: .normal)
        registerBut.backgroundColor = UIColor.blue
        registerBut.layer.cornerRadius = 5
        registerBut.addTarget(self, action: #selector(registerClicked(_:)), for: .touchUpInside)
        
        
        self.view.addSubview(phoneTF)
        self.view.addSubview(passwordTF)
        self.view.addSubview(vcodeTF)
        //self.view.addSubview(countdownBut)
        self.view.addSubview(registerBut)
        vcodeTF.addSubview(countdownBut)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        phoneTF.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight + 20)
        }
        passwordTF.snp.makeConstraints { (make) in
            make.height.equalTo(phoneTF)
            make.left.right.equalTo(phoneTF)
            make.top.equalTo(phoneTF.snp.bottom).offset(10)
        }
        vcodeTF.snp.makeConstraints { (make) in
            make.height.left.right.equalTo(phoneTF)
            make.top.equalTo(passwordTF.snp.bottom).offset(10)
        }
        countdownBut.snp.makeConstraints { (make) in
            make.top.equalTo(vcodeTF).offset(1)
            make.bottom.equalTo(vcodeTF).offset(-1)
            make.width.equalTo(90)
            make.right.equalTo(vcodeTF).offset(-1)
        }
        
        registerBut.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(vcodeTF.snp.bottom).offset(40)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
