//
//  LoginViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let mobileCellIdentifier = "mobileCellIdentifier"
fileprivate let passwordCellIdentifier = "passwordCellIdentifier"
fileprivate let vcodeCellIdentifier = "vcodeCellIdentifier"

protocol LoginProtocol {
    func didLogin(isLogin: Bool) -> Void
}

class CXMLoginViewController: BaseViewController, UITextFieldDelegate, ValidatePro, UITableViewDelegate, UITableViewDataSource, ConfigureRequestProtocol {

    //MARK: - 按钮 点击 事件
    @objc private func loginClicked(_ sender : UIButton) {
        self.passwordTF.resignFirstResponder()
        self.userNameTF.resignFirstResponder()
        guard validate(.phone, str: self.userNameTF.text) == true else {
            showHUD(message: "请输入正确的手机号")
            return }
        guard validate(.password, str: self.passwordTF.text) == true else {
            showHUD(message: "请输入6-20位数字和字母组合的密码")
            return }
        
        loginRequest()
        
        TongJi.log(.登录, label: "ios", att: .终端)
    }
    
    @objc private func registerClicked(_ sender : UIButton) {
        let register = CXMRegisterViewController()
        pushViewController(vc: register)
        TongJi.log(.新用户注册, label: "新用户注册")
    }
    
    @objc private func forgetPasswordClicked(_ sender : UIButton) {
        let forget = CXMForgetPswPhoneVC()
        pushViewController(vc: forget)
        TongJi.log(.忘记密码, label: "忘记密码")
    }
    
    @objc private func VCodeClicked(_ sender : UIButton) {
        let vcode = CXMVCodeLoginViewController()
        vcode.currentVC = self.currentVC
        pushViewController(vc: vcode)
        TongJi.log(.短信验证码登录, label: "短信验证码登录")
    }
    
    //摇一摇登录
    #if DEBUG
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        var pwd: String = "aaa123456"
        let url = UserDefaults.standard.string(forKey: kBaseUrl) ?? "https://api.caixiaomi.net"
        let baseUrl = NSURL(string: url)!
        if baseUrl.scheme == "https" {
            pwd = "aaa123456"
        }else{
            pwd = "aaa12345"
        }
        
        self.showProgressHUD()
        //登录后获取最新开关状态
        self.configRequest()
        /*
        userProvider.rx.request(.configQuety)
            .asObservable()
            .mapObject(type: ConfigInfoModel.self)
            .subscribe(onNext: { (data) in

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": data.turnOn])
                UserDefaults.standard.set(data.turnOn, forKey: TurnOn)
                UserDefaults.standard.synchronize()
                
                print("开关\(data.turnOn)")
                
                //更新消息提示 是否显示小红点
//                self.queryUserNotice(data.turnOn)
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult: break
                    
                //self.showHUD(message: msg!)
                default: break
                }
                
                let turnOn = UserDefaults.standard.bool(forKey: TurnOn)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConfig), object: nil, userInfo: ["showStyle": turnOn])
                
                
            }, onCompleted: nil, onDisposed: nil )
        */
        
//        weak var weakSelf = self
        _ = loginProvider.rx.request(.loginByPass(mobile: "18501906460", password: pwd))
            .asObservable()
            .mapObject(type: UserDataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                self.showHUD(message: data.showMsg)
                self.save(userInfo: data)
                
                if self.currentVC != nil {
                    self.popToCurrentVC()
                    if self.fromWeb {
                        NotificationCenter.default.post(name: NSNotification.Name(LoginSuccess), object: nil)
                    }
                    guard self.loginDelegate != nil else { return }
                    self.loginDelegate.didLogin(isLogin: true)
                }else {
                    self.pushRootViewController()
                }
                self.userNameTF.resignFirstResponder()
                self.passwordTF.resignFirstResponder()
                print(data)
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let hxerror = error as? HXError else { return }
                switch hxerror {
                case .UnexpectedResult(let code, let resultMsg) :
                    
                    if 300000...310000 ~= code {
                        self.showCXMAlert(title: nil, message: resultMsg!, action: "确定", cancel: nil, on: self, confirm: { (action) in
                            
                        })
                    }
                    
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    #endif
    
    //MARK: - textField DELEGATE
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textf = textField as? CustomTextField {
            textf.changeImg(string)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userNameTF {
            TongJi.log(.登录输手机号, label: "登录输手机号")
        }
        if textField == passwordTF {
            TongJi.log(.登录输密码, label: "登录输密码" )
        }
    }
    
    public var loginDelegate : LoginProtocol!
    public var fromWeb = false
    
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
        self.navigationItem.title = "密码登录"
        self.view.addSubview(tableView)
        
        //if getUserData() == nil {
            //hideBackBut()
        //}
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - 网络请求
    private func loginRequest() {
        self.showProgressHUD()
        
//        weak var weakSelf = self
       _ = loginProvider.rx.request(.loginByPass(mobile: userNameTF.text!, password: passwordTF.text!))
        .asObservable()
        .mapObject(type: UserDataModel.self)
        .subscribe(onNext: { (data) in
            self.dismissProgressHud()
            self.showHUD(message: data.showMsg)
            self.save(userInfo: data)
            
            //获取开关状态
            self.configRequest()
            
            if self.currentVC != nil {
                self.popToCurrentVC()
                if self.fromWeb {
                    NotificationCenter.default.post(name: NSNotification.Name(LoginSuccess), object: nil)
                }
                guard self.loginDelegate != nil else { return }
                self.loginDelegate.didLogin(isLogin: true)
            }else {
                self.pushRootViewController()
            }
            self.userNameTF.resignFirstResponder()
            self.passwordTF.resignFirstResponder()
            print(data)
        }, onError: { (error) in
            self.dismissProgressHud()
            guard let hxerror = error as? HXError else { return }
            switch hxerror {
            case .UnexpectedResult(let code, let resultMsg) :
                
                if 300000...310000 ~= code {
                    self.showCXMAlert(title: nil, message: resultMsg!, action: "确定", cancel: nil, on: self, confirm: { (action) in
                        
                    })
                }
                
            default: break
            }
        }, onCompleted: nil , onDisposed: nil )
        
    }
    
    //MARK: - 懒加载
    lazy private var tableView : UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = ColorF4F4F4
        table.isScrollEnabled = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        table.register(MobileTextFieldCell.self, forCellReuseIdentifier: mobileCellIdentifier)
        table.register(PasswordTextFieldCell.self, forCellReuseIdentifier: passwordCellIdentifier)
        table.register(VcodeTextFieldCell.self, forCellReuseIdentifier: vcodeCellIdentifier)
        
        let footer = LoginFooterView()
        footer.login.addTarget(self, action: #selector(loginClicked(_:)), for: .touchUpInside)
        footer.register.addTarget(self, action: #selector(registerClicked(_:)), for: .touchUpInside)
        footer.smsLogin.addTarget(self, action: #selector(VCodeClicked(_:)), for: .touchUpInside)
        footer.forget.addTarget(self, action: #selector(forgetPasswordClicked(_:)), for: .touchUpInside)
        table.tableFooterView = footer
        
        return table
    }()
    
    //MARK: - tableview datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: mobileCellIdentifier, for: indexPath) as! MobileTextFieldCell
            cell.textfield.delegate = self
            self.userNameTF = cell.textfield
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: passwordCellIdentifier, for: indexPath) as! PasswordTextFieldCell
            cell.textfield.delegate = self
            self.passwordTF = cell.textfield
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(loginTextFieldHeight)
    }
    
//    @objc override func back(_ sender: UIButton) {
//        self.passwordTF.resignFirstResponder()
//        self.userNameTF.resignFirstResponder()
//        
//        if currentVC != nil {
//            popToCurrentVC()
//            guard self.loginDelegate != nil else { return }
//            self.loginDelegate.didLogin(isLogin: false)
//        }else {
//            pushRootViewController()
//        }
//        
//    }
    
    override func back(_ sender: UIButton) {
        super.back(sender)
        TongJi.log(.登录返回, label: "登录返回")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
