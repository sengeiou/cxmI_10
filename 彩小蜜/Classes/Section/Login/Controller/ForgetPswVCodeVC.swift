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


class ForgetPswVCodeVC: BaseViewController, UITextFieldDelegate, ValidatePro,CustomTextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - 点击事件
    @objc private func confirmButClicked(_ sender: UIButton) {
        guard validate(.password, str: self.passwordTF.text) == true else {
            showHUD(message: "请输入6-20位的密码")
            return }
        guard validate(.vcode, str: self.vcodeTF.text) else {
            showHUD(message: "请输入验证码")
            return }
        
        updatePassRequest()
    }
    func countdown(button:CountdownButton) {
        guard validate(.password, str: self.passwordTF.text) == true else {
            showHUD(message: "请输入6-20位的密码")
            return }
        button.isCounting = true
        sendSmsRequest()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textf = textField as? CustomTextField {
            textf.changeImg(string)
        }
        return true
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
        self.title = "彩小秘 · 找回密码"
        self.view.addSubview(tableView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.view)
        }
    }
    //MARK: - 网络请求
    private func updatePassRequest() {
        _ = loginProvider.rx.request(.updatePass(mobile: self.phoneNum, password: self.passwordTF.text!))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe({ (event) in
                switch event {
                case .next(let data):
                    switch data.code {
                    case "0":
                        break
                    default: break
                }
                case .error(let error):
                    guard let hxError = error as? HXError else { return }
                    switch hxError {
                    case .UnexpectedResult(_, let resultMsg):
                        self.showConfirm(message: resultMsg!, confirm: { (action) in
                            
                        })
                    default : break
                    }
                case .completed : break
                }
            })
    }
    
    private func sendSmsRequest() {
        _ = loginProvider.rx.request(.sendSms(mobile: self.phoneNum, smsType: "1"))
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
