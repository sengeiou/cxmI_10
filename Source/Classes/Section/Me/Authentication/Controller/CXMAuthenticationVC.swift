//
//  AuthenticationVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/8.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

protocol AuthenticationVCDelegate {
    func didAuthentication(vc : CXMAuthenticationVC) -> Void
}

class CXMAuthenticationVC: BaseViewController, UITextFieldDelegate, ValidatePro {

    
    
    
    
    //MARK: - 属性
    public var delegate : AuthenticationVCDelegate!
    
    private var nameTF : UITextField! //姓名输入框
    private var IDNumberTF : UITextField! // 身份证号输入
    private var authenticationBut : UIButton! // 认证按钮
    private var alertTitleLB : UILabel! //顶部警告
    private var alertLB : UILabel! // 警告语
    
    private var bgView : UIView!
    private var line : UIView!
    
    private var nameIcon : UIImageView!
    private var nameTitle : UILabel!
    
    private var idIcon : UIImageView!
    private var idTitle : UILabel!
    
    
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "实名认证"
        initSubView()
    }
    //MARK: - 点击事件
    @objc private func authenticationClicked(_ sender: UIButton) {
        
        guard self.nameTF.text != nil , self.nameTF.text != "" else {
            showHUD(message: "请输入正确的姓名")
            return
        }
        
        guard validate(.IDNumber, str: IDNumberTF.text) == true else {
            showHUD(message: "请输入正确的身份证号码")
            return
        }
        
        authenticationRequest() // 认证请求
        TongJi.log(.实名认证认证, label: "ios", att: .终端)
        
    }
    
    //MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTF {
            TongJi.log(.实名认证输入姓名, label: "实名认证输入姓名" )
        }else if textField == IDNumberTF {
            TongJi.log(.实名认证输入身份证, label: "实名认证输入身份证")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        if textField == nameTF {
        //            guard validate(.chinese, str: textField.text) == true else {
        //                showHUD(message: "请输入正确的姓名")
        //                return false
        //            }
        //            IDNumberTF.becomeFirstResponder()
        //        }
        //        if textField == IDNumberTF {
        //            guard validate(.IDNumber, str: textField.text) == true else {
        //                showHUD(message: "请输入正确的身份证号码")
        //                return false
        //            }
        //            textField.resignFirstResponder()
        //        }
        
        return true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        alertTitleLB.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight + 18)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(alertTitleLB.snp.bottom).offset(17.5)
            make.left.right.equalTo(self.view)
            make.height.equalTo(111)
        }
        
        line.snp.makeConstraints { (make) in
            make.height.equalTo(SeparationLineHeight)
            make.centerY.equalTo(bgView.snp.centerY)
            make.left.equalTo(bgView).offset(10)
            make.right.equalTo(bgView).offset(-10)
        }
        
        nameIcon.snp.makeConstraints { (make) in
            make.bottom.equalTo(line.snp.top).offset(-17.5)
            make.left.equalTo(bgView).offset(19)
            make.width.height.equalTo(20)
        }
        idIcon.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView).offset(-17.5)
            make.left.equalTo(bgView).offset(19)
            make.width.height.equalTo(20)
        }
        
        nameTitle.snp.makeConstraints { (make) in
            make.left.equalTo(nameIcon.snp.right).offset(10)
            make.top.equalTo(bgView).offset(10)
            make.bottom.equalTo(line.snp.top).offset(-10)
            make.width.equalTo(80)
        }
        
        idTitle.snp.makeConstraints { (make) in
            make.left.equalTo(nameTitle)
            make.width.equalTo(nameTitle)
            make.top.equalTo(line.snp.bottom).offset(10)
            make.bottom.equalTo(bgView).offset(-10)
        }
        
        nameTF.snp.makeConstraints { (make) in
            make.left.equalTo(nameTitle.snp.right).offset(0)
            make.right.equalTo(bgView).offset(-10)
            make.top.equalTo(bgView).offset(10)
            make.bottom.equalTo(line.snp.top).offset(-10)
        }
        IDNumberTF.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameTF)
            make.top.equalTo(line.snp.bottom).offset(10)
            make.bottom.equalTo(bgView).offset(-10)
        }
        authenticationBut.snp.makeConstraints { (make) in
            make.height.equalTo(buttonHeight)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.centerX.equalTo(self.view)
            make.top.equalTo(bgView.snp.bottom).offset(30)
        }
        
    }
    
    //MARK: - 网络请求
    private func authenticationRequest() {
        self.showProgressHUD()
        weak var weakSelf = self
        _ = userProvider.rx.request(.realNameAuth(idcode: self.IDNumberTF.text!, realName: self.nameTF.text!))
            .asObservable()
            .mapObject(type: RealInfoDataModel.self)
            .subscribe(onNext: { (data) in
                self.dismissProgressHud()
                self.showHUD(message: "身份认证成功")
                print(data)
                
                if self.delegate != nil {
                    self.delegate.didAuthentication(vc: self)
                }
                
                self.popViewController()
                
            }, onError: { (error) in
                self.dismissProgressHud()
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    switch code {
                    case 600:
                        weakSelf?.removeUserData()
                        weakSelf?.pushLoginVC(from: self)
                    default : break
                    }
                    
                    if 300000...310000 ~= code || code == 0{
                        print(code)
                        self.showHUD(message: msg!)
                        if code == 0 {
                            if self.delegate != nil {
                                self.delegate.didAuthentication(vc: self)
                            }
                            self.popViewController()
                        }
                    }
                default: break
                }
            }, onCompleted: nil, onDisposed: nil)
    }
    
    //MARK: - UI
    private func initSubView() {
        
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        nameIcon = UIImageView()
        nameIcon.image = UIImage(named: "name")
        
        nameTitle = UILabel()
        nameTitle.font = Font15
        nameTitle.text = "真实姓名:"
        nameTitle.textColor = Color505050
        
        idIcon = UIImageView()
        idIcon.image = UIImage(named: "IDcard")
        
        idTitle = UILabel()
        idTitle.font = Font15
        idTitle.text = "身份证号:"
        idTitle.textColor = Color505050
        
        
        alertTitleLB = UILabel()
        alertTitleLB.font = Font13
        alertTitleLB.text = """
        身份信息是领奖和提款的重要依据，请您如实填写。
        """
        alertTitleLB.textColor = ColorA0A0A0
        alertTitleLB.textAlignment = .center
        
        
        nameTF = UITextField()
        nameTF.placeholder = "确认后不可修改"
        nameTF.borderStyle = .none
        nameTF.delegate = self
        nameTF.becomeFirstResponder()
        nameTF.returnKeyType = .next
        
        IDNumberTF = UITextField()
        IDNumberTF.placeholder = "确认后不可修改"
        IDNumberTF.borderStyle = .none
        IDNumberTF.delegate = self
        IDNumberTF.keyboardType = .namePhonePad
        IDNumberTF.returnKeyType = .done
        
        authenticationBut = UIButton(type: .custom)
        authenticationBut.titleLabel?.font = Font15
        authenticationBut.setTitle("认证", for: .normal)
        authenticationBut.setTitleColor(ColorFFFFFF, for: .normal)
        authenticationBut.backgroundColor = ColorEA5504
        authenticationBut.layer.cornerRadius = 5
        authenticationBut.addTarget(self, action: #selector(authenticationClicked(_:)), for: .touchUpInside)
        
        
        self.view.addSubview(self.bgView)
        self.view.addSubview(alertTitleLB)
        bgView.addSubview(nameIcon)
        bgView.addSubview(nameTitle)
        bgView.addSubview(idIcon)
        bgView.addSubview(idTitle)
        bgView.addSubview(line)
        bgView.addSubview(nameTF)
        bgView.addSubview(IDNumberTF)
        self.view.addSubview(authenticationBut)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
