//
//  AuthenticationVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class AuthenticationVC: BaseViewController, UITextFieldDelegate, ValidatePro {

    
    //MARK: - 点击事件
    @objc private func authenticationClicked(_ sender: UIButton) {
        
        guard validate(.chinese, str: nameTF.text) == true else {
            showAlert(message: "请输入正确的姓名")
            return
        }
        guard validate(.IDNumber, str: IDNumberTF.text) == true else {
            showAlert(message: "请输入正确的身份证号码")
            return
        }
        
        authenticationRequest() // 认证请求
        
    }
    
    //MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if nameTF.isFirstResponder == false {
            guard validate(.chinese, str: nameTF.text) == true else {
                nameTF.becomeFirstResponder()
                showAlert(message: "请输入正确的姓名")
                return
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            guard validate(.chinese, str: textField.text) == true else {
                showAlert(message: "请输入正确的姓名")
                return false
            }
            IDNumberTF.becomeFirstResponder()
        }
        if textField == IDNumberTF {
            guard validate(.IDNumber, str: textField.text) == true else {
                showAlert(message: "请输入正确的身份证号码")
                return false
            }
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: - 属性
    private var nameTF : UITextField! //姓名输入框
    private var IDNumberTF : UITextField! // 身份证号输入
    private var authenticationBut : UIButton! // 认证按钮
    private var alertTitleLB : UILabel! //顶部警告
    private var alertLB : UILabel! // 警告语
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘·实名认证"
        initSubView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        alertTitleLB.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight + 20)
        }
        nameTF.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(alertTitleLB.snp.bottom).offset(10)
        }
        IDNumberTF.snp.makeConstraints { (make) in
            make.height.left.right.equalTo(nameTF)
            make.top.equalTo(nameTF.snp.bottom).offset(10)
        }
        authenticationBut.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(150)
            make.centerX.equalTo(self.view)
            make.top.equalTo(IDNumberTF.snp.bottom).offset(30)
        }
        alertLB.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(authenticationBut.snp.bottom).offset(90)
        }
    }
    
    //MARK: - 网络请求
    private func authenticationRequest() {
        _ = userProvider.rx.request(.realNameAuth(idcode: self.IDNumberTF.text!, realName: self.nameTF.text!))
            .asObservable()
            .mapObject(type: RealInfoDataModel.self)
            .subscribe(onNext: { (data) in
                self.showHUD(message: "身份认证成功")
                print(data)
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
    }
    
    //MARK: - UI
    private func initSubView() {
        alertTitleLB = UILabel()
        alertTitleLB.font = Font12
        alertTitleLB.text = """
        身份信息是领奖、提款的重要依据，请如实填写本人身份信息。
        """
        alertTitleLB.textColor = UIColor.black
        
        nameTF = UITextField()
        nameTF.placeholder = "请输入姓名"
        nameTF.borderStyle = .roundedRect
        let nameLeftView = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        nameLeftView.text = "姓名"
        nameTF.leftView = nameLeftView
        nameTF.leftViewMode = .always
        nameTF.delegate = self
        nameTF.becomeFirstResponder()
        nameTF.returnKeyType = .next
        
        IDNumberTF = UITextField()
        IDNumberTF.placeholder = "请输入身份证号"
        IDNumberTF.borderStyle = .roundedRect
        IDNumberTF.delegate = self
        IDNumberTF.keyboardType = .namePhonePad
        IDNumberTF.returnKeyType = .done
        
        authenticationBut = UIButton(type: .custom)
        authenticationBut.setTitle("认证", for: .normal)
        authenticationBut.setTitleColor(UIColor.black, for: .normal)
        authenticationBut.backgroundColor = UIColor.gray
        authenticationBut.layer.cornerRadius = 5
        authenticationBut.addTarget(self, action: #selector(authenticationClicked(_:)), for: .touchUpInside)
        
        alertLB = UILabel()
        alertLB.font = Font12
        alertLB.text = "身份信息认证通过后将不可修改，请谨慎填写。"
        alertLB.textColor = UIColor.black
        
        
        self.view.addSubview(alertTitleLB)
        self.view.addSubview(nameTF)
        self.view.addSubview(IDNumberTF)
        self.view.addSubview(authenticationBut)
        self.view.addSubview(alertLB)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
