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

class LoginViewController: BaseViewController, UITextFieldDelegate, ValidatePro, UserInfoPro, UITableViewDelegate, UITableViewDataSource {

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
    
    @objc private func VCodeClicked(_ sender : UIButton) {
        let vcode = VCodeLoginViewController()
        
        self.navigationController?.pushViewController(vcode, animated: true)
    }
    
    //MARK: - textField DELEGATE
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textf = textField as? CustomTextField {
            textf.changeImg(string)
        }
        
        return true
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
        self.navigationItem.title = "彩小秘 · 密码登录"
        self.view.addSubview(tableView)
        
        if getUserData() == nil {
            hideBackBut()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - 网络请求
    private func loginRequest() {
       _ = loginProvider.rx.request(.loginByPass(mobile: userNameTF.text!, password: passwordTF.text!))
        .asObservable()
        .mapObject(type: UserDataModel.self)
        .subscribe { (event) in
            switch event {
            case .next(let data):
                
                self.showHUD(message: data.showMsg)
                
                if self.getUserData() == nil {
                    self.save(userInfo: data)
                    self.pushRootViewController()
                }else {
                    self.save(userInfo: data)
                    self.popToCurrentVC()
                }
                
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
