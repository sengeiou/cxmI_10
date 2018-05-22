//
//  VCodeLoginViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
fileprivate let mobileCellIdentifier = "mobileCellIdentifier"
fileprivate let passwordCellIdentifier = "passwordCellIdentifier"
fileprivate let vcodeCellIdentifier = "vcodeCellIdentifier"

class VCodeLoginViewController: BaseViewController, UITextFieldDelegate, ValidatePro, CustomTextFieldDelegate , UITableViewDataSource, UITableViewDelegate{
    
    
    
    //MARK: - 按钮 点击 事件
    @objc private func loginClicked(_ sender : UIButton) {
        self.userNameTF.resignFirstResponder()
        self.vcodeTF.resignFirstResponder()
        
        guard validate(.phone, str: self.userNameTF.text) == true else {
            showHUD(message: "请输入正确的手机号")
            return }
        guard validate(.number, str: self.vcodeTF.text) == true else {
            showHUD(message: "请输入验证码")
            return }
        loginRequest()
        TongJi.log(.验证码登录页登录, label: "ios", att: .终端)
    }
    
    @objc private func registerClicked(_ sender : UIButton) {
        self.countdownBut.stop = true
        let register = RegisterViewController()
        pushViewController(vc: register)
    }
    
    @objc private func pswLoginClicked(_ sender : UIButton) {
        self.countdownBut.stop = true
        let vcode = LoginViewController()
        vcode.currentVC = self.currentVC
        pushViewController(vc: vcode)
    }
    
    func countdown(button:CountdownButton) {
        guard validate(.phone, str: self.userNameTF.text) == true else {
            showHUD(message: "请输入正确的手机号")
            return }
        button.isCounting = true
        //showHUD(message: "验证码已发送，请注意查收")
        sendSmsRequest()
        TongJi.log(.验证码登录获取验证码, label: "ios", att: .终端)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textf = textField as? CustomTextField {
            textf.changeImg(string)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userNameTF {
            TongJi.log(.验证码登录输手机号, label: nil)
        }
        else if textField == vcodeTF {
            TongJi.log(.验证码登录输入验证码, label: "ios", att: .终端)
        }
    }
    
    public var loginDelegate : LoginProtocol!
    //MARK: - 属性
    private var userNameTF : UITextField!
    private var vcodeTF    : UITextField!
    
    private var loginBut : UIButton!
    
    private var countdownBut : CountdownButton!
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 短信登录"
        self.view.addSubview(tableView)
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
        _ = loginProvider.rx.request(.loginBySms(mobile: self.userNameTF.text!, smsCode: self.vcodeTF.text!))
            .asObservable()
            .mapObject(type: UserDataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                self.showHUD(message: data.showMsg)
                self.save(userInfo: data)
                
                self.countdownBut.stop = true
                
                if self.currentVC != nil {
                    self.popToCurrentVC()
                    guard self.loginDelegate != nil else { return }
                    self.loginDelegate.didLogin(isLogin: true)
                }else {
                    self.pushRootViewController()
                }
                
                print(data)
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let hxerror = error as? HXError else { return }
                switch hxerror {
                case .UnexpectedResult(let code, let resultMsg) :
                    if 300000...310000 ~= code {
                        if code == 301016, let resultMsg = resultMsg {
                            self.showHUD(message: resultMsg)// 输入正确的验证码
                        }else {
                            self.showCXMAlert(title: nil, message: resultMsg!, action: "确定", cancel: nil, on: self, confirm: { (action) in
                                
                            })
                        }
                    }
                default: break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    private func sendSmsRequest() {
        self.showProgressHUD()
        _ = loginProvider.rx.request(.sendSms(mobile: self.userNameTF.text!, smsType: "0"))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                if let code = Int(data.code) {
                    if code == 0 {
                        self.showHUD(message: data.msg)
                    }
                    
                    if 300000...310000 ~= code{
                        if code == 301014 {
                            //self.showHUD(message: data.msg)
                            //self.popViewController()
                            self.countdownBut.stop = true
                            self.showCXMAlert(title: nil, message: data.msg, action: "确定", cancel: nil, on: self, confirm: { (action) in
                                
                            })
                            
                        }else{
                                self.showHUD(message: data.msg)
                        }
                    }
                }
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let hxError = error as? HXError else { return }
                switch hxError {
                case .UnexpectedResult(let code, let resultMsg):
                    if code == 301016, let resultMsg = resultMsg {
                        self.showHUD(message: resultMsg)
                    }else {
                        self.showCXMAlert(title: nil, message: resultMsg!, action: "确定", cancel: nil, on: self, confirm: { (action) in
                            
                        })
                    }
                default : break
                }
            }, onCompleted: nil , onDisposed: nil )
        

    }
    
    //MARK: - 懒加载
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
        
        let footer = VCodeLoginFooterView()
        footer.login.addTarget(self, action: #selector(loginClicked(_:)), for: .touchUpInside)
        footer.register.addTarget(self, action: #selector(registerClicked(_:)), for: .touchUpInside)
        footer.pswLogin.addTarget(self, action: #selector(pswLoginClicked(_:)), for: .touchUpInside)
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: vcodeCellIdentifier, for: indexPath) as! VcodeTextFieldCell
            cell.textfield.delegate = self
            cell.textfield.customDelegate = self
            self.countdownBut = cell.textfield.countdownBut
            self.vcodeTF = cell.textfield
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(loginTextFieldHeight)
    }
    
    
    @objc override func back(_ sender: UIButton) {
        self.vcodeTF.resignFirstResponder()
        self.userNameTF.resignFirstResponder()
        
        if currentVC != nil {
            popToCurrentVC()
            guard self.loginDelegate != nil else { return }
            self.loginDelegate.didLogin(isLogin: false)
        }else {
            pushRootViewController()
        }
        TongJi.log(.验证码登录返回, label: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
