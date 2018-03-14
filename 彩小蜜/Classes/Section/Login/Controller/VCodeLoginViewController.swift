//
//  VCodeLoginViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class VCodeLoginViewController: BaseViewController, UITextFieldDelegate, CountdownButtonDelegate, ValidatePro, UserInfoPro {
    
    
    
    //MARK: - 按钮 点击 事件
    @objc private func loginClicked(_ sender : UIButton) {
        guard validate(.phone, str: self.userNameTF.text) == true else {
            showHUD(message: "请输入正确的手机号")
            return }
        guard validate(.vcode, str: self.vcodeTF.text) == true else {
            showHUD(message: "请输入验证码")
            return }
        loginRequest()
    }
    
    func countdownButClicked(button: CountdownButton) {
        guard validate(.phone, str: self.userNameTF.text) == true else {
            showHUD(message: "请输入正确的手机号")
            return }
        showHUD(message: "验证码已发送，请注意查收")
        sendSmsRequest()
    }
    
    //MARK: - 属性
    private var userNameTF : UITextField!
    private var vcodeTF    : UITextField!
    
    private var loginBut : UIButton!
    
    private var countdownBut : CountdownButton!
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘·登录"
        creatUI()
        
    }
    
    //MARK: - 网络请求
    private func loginRequest() {
        _ = loginProvider.rx.request(.loginBySms(mobile: self.userNameTF.text!, smsCode: self.vcodeTF.text!))
            .asObservable()
            .mapObject(type: UserDataModel.self)
            .subscribe { (event) in
                switch event {
                case .next(let data):
                    weak var weakSelf = self
                    self.save(userInfo: data)
                    self.showConfirm(message: data.showMsg, confirm: { (action) in
                        weakSelf?.pushRootViewController()
                    })
                    print(data)
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
    private func sendSmsRequest() {
        _ = loginProvider.rx.request(.sendSms(mobile: self.userNameTF.text!, smsType: "0"))
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
    private func creatUI() {
        userNameTF = CustomTextField(imageName : "userID")
        vcodeTF = CustomTextField(imageName : "userID")
        
        self.view.addSubview(userNameTF)
        self.view.addSubview(vcodeTF)
        
        userNameTF.delegate = self
        vcodeTF.delegate = self
        
        userNameTF.borderStyle = .roundedRect
        vcodeTF.borderStyle = .roundedRect
        
        userNameTF.placeholder = "请输入手机号"
        vcodeTF.placeholder = "请输入验证码"
        
        userNameTF.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight + 20)
        }
        
        vcodeTF.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(userNameTF.snp.bottom).offset(20)
        }
        
        
        // button
        
        loginBut = UIButton(type: .custom)
        
        self.view.addSubview(loginBut)
        
        loginBut.layer.cornerRadius = 5
        
        loginBut.setTitle("登录", for: .normal)
        
        loginBut.backgroundColor = UIColor.blue
        
        loginBut.setTitleColor(UIColor.black, for: .normal)
        
        loginBut.addTarget(self, action: #selector(loginClicked(_:)), for:.touchUpInside)
        
        loginBut.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(vcodeTF.snp.bottom).offset(40)
        }
       
        // countdown button
        countdownBut = CountdownButton()
        
        self.view.addSubview(countdownBut)
        
        countdownBut.delegate = self
        
        countdownBut.snp.makeConstraints { (make) in
            make.top.equalTo(loginBut.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(180)
            make.right.equalTo(self.view).offset(-20)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
