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


class ForgetPswPhoneVC: BaseViewController, UITextFieldDelegate, ValidatePro, UITableViewDataSource, UITableViewDelegate {

    //MARK: - 点击事件
    @objc private func confirmButClicked(_ sender : UIButton) {

        guard validate(.phone, str: self.phoneTF.text) == true else {
            showAlert(message: "请输入合法的手机号")
            return
        }
        validateMobileRequest()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textf = textField as? CustomTextField {
            textf.changeImg(string)
        }
        
        return true
    }
    
    //MARK: - 属性
    private var phoneTF : CustomTextField!
    private var confirmBut : UIButton!
    
    
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
        _ = loginProvider.rx.request(.sendSms(mobile: self.phoneTF.text!, smsType: "2"))
            .asObservable()
            .mapBaseObject(type: DataModel.self)
            .subscribe { (event) in
                switch event {
                case .next(let data):
                    switch data.code {
                    case "0" :
                        self.showHUD(message: "验证码已发送，请注意查收")
                        let vcode = ForgetPswVCodeVC()
                        vcode.phoneNum = self.phoneTF.text
                        self.pushViewController(vc: vcode)
                    case "301010":
                        self.showHUD(message: data.msg)
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
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
