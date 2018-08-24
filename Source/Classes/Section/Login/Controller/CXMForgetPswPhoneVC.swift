//
//  ForgetPswPhoneVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let mobileCellIdentifier = "mobileCellIdentifier"
fileprivate let passwordCellIdentifier = "passwordCellIdentifier"
fileprivate let vcodeCellIdentifier = "vcodeCellIdentifier"


class CXMForgetPswPhoneVC: BaseViewController, UITextFieldDelegate, ValidatePro, UITableViewDataSource, UITableViewDelegate {

    //MARK: - 点击事件
    @objc private func confirmButClicked(_ sender : UIButton) {
        self.phoneTF.resignFirstResponder()
        guard validate(.phone, str: self.phoneTF.text) == true else {
            showHUD(message: "请输入合法的手机号")
            return
        }
        validateMobileRequest()
        TongJi.log(.忘记密码下一步, label: "忘记密码下一步")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textf = textField as? CustomTextField {
            textf.changeImg(string)
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneTF {
            TongJi.log(.忘记密码输入手机号, label: "忘记密码输入手机号")
        }
    }
    
    
    //MARK: - 属性
    private var phoneTF : CustomTextField!
    private var confirmBut : UIButton!
    
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "找回密码"
        self.view.addSubview(tableView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - 网络请求
    private func validateMobileRequest() {
        weak var weakSelf = self
        self.showProgressHUD()
        _ = loginProvider.rx.request(.validateMobile(mobile: self.phoneTF.text!))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                if data.code == "0" {
                    self.sendSmsRequest()
                }
                
                if let code = Int(data.code) {
                    
                    if 300000...310000 ~= code {
                        if code == 301014 {
                            self.showCXMAlert(title: nil, message: data.msg, action: "确定", cancel: nil, on: self, confirm: { (action) in
                                guard weakSelf != nil else { return }
                                let register = CXMRegisterViewController()
                                weakSelf?.pushViewController(vc: register)
                            })
                        }else {
                            weakSelf?.showHUD(message: data.msg)
                        }
                    }
                }
            }, onError: { (error) in
                self.dismissProgressHud()
            }, onCompleted: nil , onDisposed: nil )
        
    }
    private func sendSmsRequest() {
        self.showProgressHUD()
        _ = loginProvider.rx.request(.sendSms(mobile: self.phoneTF.text!, smsType: "2"))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                switch data.code {
                case "0" :
                    self.showHUD(message: "验证码已发送，请注意查收")
                    let vcode = CXMForgetPswVCodeVC()
                    vcode.phoneNum = self.phoneTF.text
                    self.pushViewController(vc: vcode)
                    TongJi.log(.忘记密码获取验证码, label: "ios", att: .终端)
                default : break
                }
                
                if let code = Int(data.code) {
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
                        self.popViewController()
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
        
        let footer = ForgetPswModileFooterView()
        footer.nextBut.addTarget(self, action: #selector(confirmButClicked(_:)), for: .touchUpInside)
        table.tableFooterView = footer
        
        return table
    }()
    //MARK: - tableview datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: mobileCellIdentifier, for: indexPath) as! MobileTextFieldCell
            cell.textfield.delegate = self
            self.phoneTF = cell.textfield
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(loginTextFieldHeight)
    }
    
    
    override func back(_ sender: UIButton) {
        super.back(sender)
        TongJi.log(.忘记密码页返回, label: "忘记密码页返回" )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
