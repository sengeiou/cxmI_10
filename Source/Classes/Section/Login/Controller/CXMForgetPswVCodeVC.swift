//
//  ForgetPswVCodeVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit
fileprivate let mobileCellIdentifier = "mobileCellIdentifier"
fileprivate let passwordCellIdentifier = "passwordCellIdentifier"
fileprivate let vcodeCellIdentifier = "vcodeCellIdentifier"


class CXMForgetPswVCodeVC: BaseViewController, UITextFieldDelegate, ValidatePro,CustomTextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - 点击事件
    @objc private func confirmButClicked(_ sender: UIButton) {
        self.passwordTF.resignFirstResponder()
        self.vcodeTF.resignFirstResponder()
        guard validate(.password, str: self.passwordTF.text) == true else {
            showHUD(message: "请输入6-20位数字和字母组合的密码")
            return }
        guard validate(.number, str: self.vcodeTF.text) else {
            showHUD(message: "请输入验证码")
            return }
        
        updatePassRequest()
        TongJi.log(.忘记密码确定, label: "ios", att: .终端)
    }
    func countdown(button:CountdownButton) {
        guard validate(.password, str: self.passwordTF.text) == true else {
            showHUD(message: "请输入6-20位数字和字母组合的密码")
            return }
        button.isCounting = true
        sendSmsRequest()
        TongJi.log(.忘记密码获取验证码, label: "ios", att: .终端)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textf = textField as? CustomTextField {
            textf.changeImg(string)
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == vcodeTF {
            TongJi.log(.忘记密码输入验证码, label: "ios", att: .终端)
        }
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
        self.title = "找回密码"
        self.view.addSubview(tableView)
        guard countdownBut != nil else { return }
        countdownBut.isCounting = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - 网络请求
    private func updatePassRequest() {
        self.showProgressHUD()
        _ = loginProvider.rx.request(.updatePass(mobile: self.phoneNum, password: self.passwordTF.text!, smsCode: self.vcodeTF.text! ))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                if let code = Int(data.code) {
                    switch code {
                    case 0:
                        self.showHUD(message: data.msg)
                        self.popToLoginViewController()
                        //self.popViewController()
                    default:
                        break
                    }
                    
                    if 300000...310000 ~= code {
                        self.showHUD(message: data.msg)
                    }
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
    
    private func sendSmsRequest() {
        self.showProgressHUD()
        _ = loginProvider.rx.request(.sendSms(mobile: self.phoneNum, smsType: "2"))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                if let code = Int(data.code) {
                    if code == 0 {
                        self.showHUD(message: data.msg)
                    }
                    if 300000...310000 ~= code{
                        self.showHUD(message: data.msg)
                    }
                }
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let hxError = error as? HXError else { return }
                switch hxError {
                case .UnexpectedResult(_, let resultMsg):
                    self.showCXMAlert(title: nil, message: resultMsg!, action: "确定", cancel: nil, on: self, confirm: { (action) in
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
        
        let footer = ForgetPswVCodeFooterView()
        footer.confirm.addTarget(self, action: #selector(confirmButClicked(_:)), for: .touchUpInside)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: passwordCellIdentifier, for: indexPath) as! PasswordTextFieldCell
            cell.textfield.delegate = self
            self.passwordTF = cell.textfield
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: vcodeCellIdentifier, for: indexPath) as! VcodeTextFieldCell
            cell.textfield.delegate = self
            cell.textfield.customDelegate = self
            if cell.textfield.countdownBut != nil {
                self.countdownBut = cell.textfield.countdownBut
                self.countdownBut.isCounting = true 
            }
            self.vcodeTF = cell.textfield
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
        // Dispose of any resources that can be recreated.
    }
    

    
}
