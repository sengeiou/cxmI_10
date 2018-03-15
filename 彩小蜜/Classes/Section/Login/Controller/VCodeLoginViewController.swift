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

class VCodeLoginViewController: BaseViewController, UITextFieldDelegate, ValidatePro, UserInfoPro, CustomTextFieldDelegate , UITableViewDataSource, UITableViewDelegate{
    
    
    
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
    
    func countdown() {
        guard validate(.phone, str: self.userNameTF.text) == true else {
            showHUD(message: "请输入正确的手机号")
            return }
        showHUD(message: "验证码已发送，请注意查收")
        sendSmsRequest()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textf = textField as? CustomTextField {
            textf.changeImg(string)
        }
        
        return true
    }
    
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
    }
    

}
