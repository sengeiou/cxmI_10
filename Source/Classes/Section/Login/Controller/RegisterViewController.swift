//
//  RegisterViewController.swift
//  彩小蜜
//
//  Created by HX on 2018/3/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let mobileCellIdentifier = "mobileCellIdentifier"
fileprivate let passwordCellIdentifier = "passwordCellIdentifier"
fileprivate let vcodeCellIdentifier = "vcodeCellIdentifier"

class RegisterViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ValidatePro, CustomTextFieldDelegate, RegisterFooterViewDelegate {
    
    
    func didTipSelectedAgreement(isAgerr: Bool) {
        self.canRegister = isAgerr
    }
    // 跳转注册协议
    func didTipAgreement() {
        let regis = WebViewController()
        regis.urlStr = webRegisterAgreement
        pushViewController(vc: regis)
        TongJi.log(.注册用户协议, label: "注册用户协议" )
    }
    
    // MARK: - 点击事件
    @objc private func registerClicked(_ sender: UIButton) {
        self.passwordTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
        self.vcodeTF.resignFirstResponder()
        
        guard canRegister else {
            showHUD(message: "请同意注册协议")
            return
        }
        guard validate(.phone, str: self.phoneTF.text) else {
            showHUD(message: "请输入正确的手机号")
            return
        }
        guard validate(.password, str: self.passwordTF.text) else{
            showHUD(message: "请输入6-20位数字和字母组合的密码")
            return
        }
        guard self.vcodeTF.text != nil else {
            showHUD(message: "请输入验证码")
            return
        }
        
        registerRequest()
        TongJi.log(.注册, label: "ios", att: .终端)
    }
    
    func countdown(button:CountdownButton) {
        guard validate(.phone, str: self.phoneTF.text) else {
            showHUD(message: "请输入合法的手机号")
            return
        }
        button.isCounting = true
        sendSmsRequest(button)
        TongJi.log(.注册获取验证码, label: "ios", att: .终端)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textf = textField as? CustomTextField {
            textf.changeImg(string)
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneTF {
            TongJi.log(.注册输手机号, label: "注册输手机号")
        }
        else if textField == passwordTF {
            TongJi.log(.注册输密码, label: "ios", att: .终端)
        }
        else if textField == vcodeTF {
            TongJi.log(.注册输入验证码, label: "ios", att: .终端)
        }
    }
    
    
    // MARK: - 属性
    private var phoneTF : CustomTextField!     // 输入手机号
    private var passwordTF : CustomTextField!  // 输入密码
    private var vcodeTF : UITextField!         // 输入验证码
    private var canRegister: Bool = true
    
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 注册"
        self.view.addSubview(tableView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    
    // MARK: 网络请求
    private func registerRequest() {
        self.showProgressHUD()
        _ = loginProvider.rx.request(.register(mobile: self.phoneTF.text!, password: self.passwordTF.text!, vcode: vcodeTF.text!))
            .asObservable()
            .mapObject(type: UserDataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                self.showHUD(message: data.showMsg)
                
                if self.getUserData() == nil {
                    self.save(userInfo: data)
                    self.pushRootViewController()
                }else {
                    self.save(userInfo: data)
                    self.popToCurrentVC()
                }
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let hxError = error as? HXError else { return }
                switch hxError {
                case .UnexpectedResult(_, let resultMsg):
                    self.showCXMAlert(title: nil, message: resultMsg!, action: "确定", cancel: nil, on: self, confirm: { (action) in
                        
                    })
                default : break
                }
            }, onCompleted: nil , onDisposed: nil )
    }
    
    private func sendSmsRequest(_ button : CountdownButton) {
        self.showProgressHUD()
        _ = loginProvider.rx.request(.sendSms(mobile: self.phoneTF.text!, smsType: "1"))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                if let code = Int(data.code) {
                    if code == 0 {
                        self.showHUD(message: data.msg)
                    }
                    if 300000...310000 ~= code{
                        switch code {
                        case 301010 :
                            self.showCXMAlert(title: nil, message: data.msg, action: "确定", cancel: nil, on: self, confirm: { (action) in
                                 self.popViewController()
                            })
                            button.isCounting = false
                        default :
                            self.showHUD(message: data.msg)
                        }
                    }
                }
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let hxError = error as? HXError else { return }
                switch hxError {
                case .UnexpectedResult(_, let resultMsg):
                    self.showCXMAlert(title: nil, message: resultMsg!, action: "确定", cancel: nil, confirm: { (action) in
                        //self.popViewController()
                    })
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
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTipTap))
        table.addGestureRecognizer(tap)
        let footer = RegisterFooterView()
        
        footer.delegate = self
        footer.register.addTarget(self, action: #selector(registerClicked(_:)), for: .touchUpInside)
        table.tableFooterView = footer
        
        return table
    }()
    
    //MARK: - tableview dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: mobileCellIdentifier, for: indexPath) as! MobileTextFieldCell
            cell.textfield.delegate = self
            self.phoneTF = cell.textfield
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: passwordCellIdentifier, for: indexPath) as! PasswordTextFieldCell
            cell.textfield.delegate = self
            self.passwordTF = cell.textfield
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: vcodeCellIdentifier, for: indexPath) as! VcodeTextFieldCell
            cell.textfield.delegate = self
            cell.textfield.customDelegate = self
            self.vcodeTF = cell.textfield
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(loginTextFieldHeight)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.passwordTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
        self.vcodeTF.resignFirstResponder()
    }
    
    @objc private func didTipTap() {
        self.passwordTF.resignFirstResponder()
        self.phoneTF.resignFirstResponder()
        self.vcodeTF.resignFirstResponder()
    }
    
    override func back(_ sender: UIButton) {
        super.back(sender)
        TongJi.log(.注册页返回, label: "注册页返回")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
