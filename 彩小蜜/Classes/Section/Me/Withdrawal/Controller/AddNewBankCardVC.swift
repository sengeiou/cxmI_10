//
//  AddNewBankCardVC.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class AddNewBankCardVC: BaseViewController, UITextFieldDelegate, ValidatePro {

    //MARK: - 点击事件
    @objc private func addNewCard(_ sender: UIButton) {

        var str = self.cardNumTF.text
        str = str?.replacingOccurrences(of: " ", with: "")
        
        guard validate(.bankCard, str: str) else {
            showAlert(message: " 银行卡不正确，请核对后重新添加")
            return
        }
        print(str!)
        addBankCardRequest()
    }
    //MARK: - 属性
    private var nameLB : UILabel! // 名字
    private var cardNumTF : UITextField! // 银行卡号输入
    private var alertLB : UILabel! // 警告语
    private var addCardBut : UIButton! // 添加按钮
    private var instructionsTitle : UILabel! // 温馨提示
    private var instructions : UILabel! // 温馨提示
    
    private var realInfo : RealInfoDataModel!
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘·添加银行卡"
        realInfoRequest()
        initSubview()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameLB.snp.makeConstraints { (make) in
            make.height.equalTo(labelHeight)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(self.view).offset(SafeAreaTopHeight + 20)
        }
        cardNumTF.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(nameLB.snp.bottom).offset(20)
        }
        alertLB.snp.makeConstraints { (make) in
            make.height.equalTo(labelHeight)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(cardNumTF.snp.bottom).offset(5)
        }
        addCardBut.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(150)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(alertLB.snp.bottom).offset(80)
        }
        instructionsTitle.snp.makeConstraints { (make) in
            make.height.equalTo(labelHeight)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(addCardBut.snp.bottom).offset(100)
        }
        instructions.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(instructionsTitle.snp.bottom).offset(1)
        }
    }

    //MARK: - 网络请求
    // 实名认证信息
    private func realInfoRequest() {
        _ = userProvider.rx.request(.realInfo)
            .asObservable()
            .mapObject(type: RealInfoDataModel.self)
            .subscribe(onNext: { (data) in
                self.realInfo = data
            }, onError: { (error) in
                guard let err = error as? HXError else { return }
                switch err {
                case .UnexpectedResult(let code, let msg):
                    print(code!)
                    self.showHUD(message: msg!)
                default: break
                }
            }, onCompleted: nil, onDisposed: nil )
    }
    
    private func addBankCardRequest() {
        _ = userProvider.rx.request(.addBankCard(bankCardNo: self.cardNumTF.text!, realName: self.realInfo.realName))
        .asObservable()
        .mapObject(type: BankCardInfo.self)
            .subscribe(onNext: { (data) in
                self.showHUD(message: data.showMsg)
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
    private func initSubview() {
        nameLB = UILabel()
        nameLB.font = Font14
        nameLB.text = "笑笑"
        nameLB.textColor = UIColor.black
        nameLB.textAlignment = .left
        
        cardNumTF = UITextField()
        cardNumTF.font = Font13
        cardNumTF.placeholder = "请输入银行卡号"
        cardNumTF.borderStyle = .roundedRect
        cardNumTF.keyboardType = .numberPad
        cardNumTF.delegate = self
        
        let alertStr = NSMutableAttributedString(string: " 该卡号为默认收款")
        let imageText = NSTextAttachment()
        imageText.image = UIImage(named: "eye")
        imageText.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        
        let imageAtt = NSAttributedString(attachment: imageText)
        
        alertStr.insert(imageAtt, at: 0)
        
        alertLB = UILabel()
        alertLB.font = Font12
        alertLB.attributedText = alertStr
        alertLB.textColor = UIColor.red
        
        addCardBut = UIButton(type: .custom)
        addCardBut.setTitle("添加", for: .normal)
        addCardBut.setTitleColor(UIColor.white, for: .normal)
        addCardBut.backgroundColor = UIColor.green
        addCardBut.layer.cornerRadius = 5
        addCardBut.addTarget(self, action: #selector(addNewCard(_:)), for: .touchUpInside)
        
        instructionsTitle = UILabel()
        instructionsTitle.font = Font14
        instructionsTitle.textColor = UIColor.black
        instructionsTitle.text = "温馨提示"
        instructionsTitle.textAlignment = .center
        
        instructions = UILabel()
        instructions.font = Font12
        instructions.textColor = UIColor.black
        instructions.numberOfLines = 0
        instructions.text = """
        1.建议使用：中国银行 工商银行 招商银行 建设银行卡，提现更快捷；
        2.请务必确保银行卡开户名与实名认证的姓名一致；
        3.请使用储蓄卡作为收款银行卡；
        4.添加银行卡可能会有信息延迟，请耐心等待，如添加未成功请再次添加；
        """
        
        self.view.addSubview(nameLB)
        self.view.addSubview(cardNumTF)
        self.view.addSubview(alertLB)
        self.view.addSubview(addCardBut)
        self.view.addSubview(instructionsTitle)
        self.view.addSubview(instructions)
        
    }
    
    
    //MARK: -
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var text = cardNumTF.text! as NSString
        
        let characterSet = NSCharacterSet(charactersIn: "0123456789")
        var string = string
        string = string.replacingOccurrences(of: " ", with: "")
        
//        if string.rangeOfCharacter(from: characterSet.inverted ) != NSNotFound {
//            return false
//        }
        
        text = text.replacingCharacters(in: range, with: string) as NSString
        text = text.replacingOccurrences(of: " ", with: "") as NSString
        
        var newString: NSString = ""
       
        while text.length > 0{
            let subString: NSString = text.substring(to: [text.length, 4].min()!) as NSString
            
            newString = newString.appending(subString as String) as NSString
            if (subString.length == 4) {
                newString = newString.appending(" ") as NSString
            }
            text = text.substring(from: [text.length, 4].min()!) as NSString
        }
        newString = newString.trimmingCharacters(in: characterSet.inverted) as NSString
        
        if (newString.length >= 24) {
            return false
        }
        self.cardNumTF.text = newString as String
        
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
