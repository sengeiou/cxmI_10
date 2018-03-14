//
//  LoginViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import SnapKit


class LoginViewController: BaseViewController, UITextFieldDelegate, ValidatePro, UserInfoPro {

    //MARK: - 按钮 点击 事件
    @objc private func loginClicked(_ sender : UIButton) {
        guard validate(.phone, str: self.userNameTF.text) == true else {
            showHUD(message: "请输入手机号")
            return }
        guard validate(.password, str: self.passwordTF.text) == true else {
            showHUD(message: "请输入密码")
            return }
        loginRequest()
    }
    
    @objc private func registerClicked(_ sender : UIButton) {
        let register = RegisterViewController()
        pushViewController(vc: register)
    }
    
    @objc private func forgetPasswordClicked(_ sender : UIButton) {
        let forget = ForgetPswPhoneVC()
        self.navigationController?.pushViewController(forget, animated: true)
    }
    
    @objc private func VerificationCodeClicked(_ sender : UIButton) {
        let vcode = VCodeLoginViewController()
        
        self.navigationController?.pushViewController(vcode, animated: true)
    }
    
    //MARK: - textField DELEGATE
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    
    //Mark: - 属性
    private var userNameTF : UITextField!
    private var passwordTF : UITextField!
    
    private var loginBut    : UIButton!
    private var registerBut : UIButton!
    
    private var VerificationCodeBut : UIButton!
    private var forgetPasswordBut   : UIButton!
    
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "彩小秘·登录"
        
        creatUI() // 创建UI
        
    }

    //MARK: - 网络请求
    private func loginRequest() {
       _ = loginProvider.rx.request(.loginByPass(mobile: "13601180392", password: "123456"))
        .asObservable()
        .mapObject(type: UserDataModel.self)
        .subscribe { (event) in
            switch event {
            case .next(let data):
                weak var weakSelf = self
                self.showConfirm(message: data.showMsg, confirm: { (action) in
                    weakSelf?.pushRootViewController()
                })
                print(data)
                self.save(userInfo: data)
            case .error(let error):
                guard let hxerror = error as? HXError else { return }
                switch hxerror {
                case .UnexpectedResult(_, let resultMsg) :
                    self.showConfirm(message: resultMsg!, confirm: { (action) in
                        self.popViewController()
                    })
                default: break
                }
            case .completed:
                break
            }
        }
        
    }
    
    //MARK: - UI
    private func creatUI() {
        userNameTF = CustomTextField(imageName : "userID")
        passwordTF = CustomTextField(imageName : "userID")
        
        self.view.addSubview(userNameTF)
        self.view.addSubview(passwordTF)
        
        userNameTF.delegate = self
        passwordTF.delegate = self
        
        userNameTF.borderStyle = .roundedRect
        passwordTF.borderStyle = .roundedRect
        
        userNameTF.placeholder = "请输入手机号"
        passwordTF.placeholder = "请输入密码"
        
        userNameTF.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight + 20)
        }
        
        passwordTF.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(userNameTF.snp.bottom).offset(20)
        }
        
        
        // button
        
        loginBut = UIButton(type: .custom)
        registerBut = UIButton(type: .custom)
        forgetPasswordBut   = UIButton(type: .custom)
        VerificationCodeBut = UIButton(type: .custom)
        
        
        self.view.addSubview(loginBut)
        self.view.addSubview(registerBut)
        self.view.addSubview(forgetPasswordBut)
        self.view.addSubview(VerificationCodeBut)
        
        
        loginBut.layer.cornerRadius = 5
        registerBut.layer.cornerRadius = 5
        
        
        loginBut.setTitle("登录", for: .normal)
        registerBut.setTitle("新用户注册", for: .normal)
        forgetPasswordBut.setTitle("忘记密码?", for: .normal)
        VerificationCodeBut.setTitle("短信验证码登录", for: .normal)
        
        
        forgetPasswordBut.contentHorizontalAlignment = .right
        VerificationCodeBut.contentHorizontalAlignment = .left
        
        
        forgetPasswordBut.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        VerificationCodeBut.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        
        loginBut.backgroundColor = UIColor.blue
        registerBut.backgroundColor = UIColor.red
        forgetPasswordBut.backgroundColor = UIColor.white
        VerificationCodeBut.backgroundColor = UIColor.white
        
        
        loginBut.setTitleColor(UIColor.black, for: .normal)
        registerBut.setTitleColor(UIColor.black, for: .normal)
        forgetPasswordBut.setTitleColor(UIColor.black, for: .normal)
        VerificationCodeBut.setTitleColor(UIColor.black, for: .normal)
        
        
        loginBut.addTarget(self, action: #selector(loginClicked(_:)), for:.touchUpInside)
        registerBut.addTarget(self, action: #selector(registerClicked(_:)), for: .touchUpInside)
        forgetPasswordBut.addTarget(self, action: #selector(forgetPasswordClicked(_:)), for: .touchUpInside)
        VerificationCodeBut.addTarget(self, action: #selector(VerificationCodeClicked(_:)), for: .touchUpInside)
        
        
        loginBut.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(passwordTF.snp.bottom).offset(40)
        }
        registerBut.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(loginBut.snp.bottom).offset(20)
        }
        VerificationCodeBut.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(forgetPasswordBut)
            make.left.equalTo(self.view).offset(20)
            make.top.equalTo(registerBut.snp.bottom).offset(20)
            make.right.equalTo(forgetPasswordBut.snp.left).offset(-10)
        }
        forgetPasswordBut.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.top.equalTo(VerificationCodeBut)
            make.width.equalTo(VerificationCodeBut)
            make.right.equalTo(self.view).offset(-20)
        }
        

    }
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
