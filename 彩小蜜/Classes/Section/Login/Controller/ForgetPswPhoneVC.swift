//
//  ForgetPswPhoneVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class ForgetPswPhoneVC: BaseViewController, UITextFieldDelegate, ValidatePro {

    //MARK: - 点击事件
    @objc private func confirmButClicked(_ sender : UIButton) {
        
        guard validate(.phone, str: self.phoneTF.text) == true else {
            showAlert(message: "请输入合法的手机号")
            return
        }
        validateMobileRequest()
    }
    
    //MARK: - 属性
    private var phoneTF : CustomTextField!
    private var confirmBut : UIButton!
    
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘·找回密码"
        creatUI() //创建UI
    }

    //MARK: - 网络请求
    private func validateMobileRequest() {
        _ = loginProvider.rx.request(.validateMobile(mobile: self.phoneTF.text!))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe { (event) in
                switch event {
                case .next(let data):
                    weak var weakSelf = self
                    switch data.code {
                    case "0":
                        self.sendSmsRequest()
                        self.showHUD(message: "验证码已发送，请注意查收")
                        let vcode = ForgetPswVCodeVC()
                        vcode.phoneNum = self.phoneTF.text
                        self.pushViewController(vc: vcode)
                    case "301014":
                        self.showConfirm(message: data.msg, action: "去注册", confirm: { (action) in
                            guard weakSelf != nil else { return }
                            let register = RegisterViewController()
                            weakSelf?.pushViewController(vc: register)
                        })
                    default :
                        break
                    }
                case .error(let error) :
                    print(error)
                case .completed: break
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
        // TextField
        phoneTF = CustomTextField(imageName: "userID")
        phoneTF.delegate = self
        phoneTF.borderStyle = .roundedRect
        phoneTF.placeholder = "请输入要找回的手机号"
        phoneTF.keyboardType = .numberPad
        
        // button
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitle("下一步", for: .normal)
        confirmBut.setTitleColor(UIColor.white, for: .normal)
        confirmBut.backgroundColor = UIColor.blue
        confirmBut.layer.cornerRadius = 5
        confirmBut.addTarget(self, action: #selector(confirmButClicked(_:)), for: .touchUpInside)
        
        
        self.view.addSubview(phoneTF)
        self.view.addSubview(confirmBut)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        phoneTF.snp.makeConstraints { (make) in
            make.height.equalTo(45)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight + 20)
        }
        confirmBut.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(phoneTF.snp.bottom).offset(50)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
