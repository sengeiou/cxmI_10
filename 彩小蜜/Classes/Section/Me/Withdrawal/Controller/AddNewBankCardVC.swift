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
    private var nameTitle : UILabel!
    private var cardNumTF : UITextField! // 银行卡号输入
    private var alertLB : UILabel! // 警告语
    private var addCardBut : UIButton! // 添加按钮
    private var instructions : UITextView! // 温馨提示
    private var bgView : UIView!
    private var hLine : UIView!
    
    private var realInfo : RealInfoDataModel!
    //MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彩小秘 · 添加银行卡"
        realInfoRequest()
        initSubview()
    }
    

    //MARK: - 网络请求
    // 实名认证信息
    private func realInfoRequest() {
        _ = userProvider.rx.request(.realInfo)
            .asObservable()
            .mapObject(type: RealInfoDataModel.self)
            .subscribe(onNext: { (data) in
                self.realInfo = data
                self.nameLB.text = data.realName
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
        _ = userProvider.rx.request(.addBankCard(bankCardNo: self.cardNumTF.text!))
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(SafeAreaTopHeight)
            make.left.right.equalTo(self.view)
            make.height.equalTo(111)
        }
        
        hLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView.snp.centerY)
            make.left.equalTo(bgView).offset(10)
            make.right.equalTo(bgView).offset(-10)
            make.height.equalTo(SeparationLineHeight)
        }
        
        nameTitle.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(leftSpacing)
            make.width.equalTo(45)
            make.top.equalTo(bgView)
            make.bottom.equalTo(hLine.snp.top)
        }
        
        nameLB.snp.makeConstraints { (make) in
            make.left.equalTo(nameTitle.snp.right)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.top.equalTo(bgView)
            make.bottom.equalTo(hLine.snp.top)
        }
        cardNumTF.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(leftSpacing)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.top.equalTo(hLine.snp.bottom)
            make.bottom.equalTo(bgView)
        }
        alertLB.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(bgView).offset(leftSpacing)
            make.right.equalTo(bgView).offset(-rightSpacing)
            make.top.equalTo(bgView.snp.bottom).offset(17.5)
        }
        addCardBut.snp.makeConstraints { (make) in
            make.height.equalTo(loginButHeight)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(bgView.snp.bottom).offset(loginButTopSpacing*2)
        }
        
        instructions.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.left.equalTo(self.view).offset(leftSpacing)
            make.right.equalTo(self.view).offset(-rightSpacing)
            make.top.equalTo(addCardBut.snp.bottom).offset(loginButTopSpacing*2 - 10)
        }
    }
    //MARK: - UI
    private func initSubview() {
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        hLine = UIView()
        hLine.backgroundColor = ColorF4F4F4
        
        nameTitle = UILabel()
        nameTitle.font = Font14
        nameTitle.text = "姓名:"
        nameTitle.textColor = ColorA0A0A0
        nameTitle.textAlignment = .left
        
        nameLB = UILabel()
        nameLB.font = Font14
        nameLB.textColor = Color505050
        nameLB.textAlignment = .left
        
        cardNumTF = UITextField()
        cardNumTF.font = Font13
        cardNumTF.placeholder = "请输入银行卡号"
        //cardNumTF.borderStyle = .roundedRect
        cardNumTF.keyboardType = .numberPad
        cardNumTF.delegate = self
        
//        let alertStr = NSMutableAttributedString(string: " 该卡号为默认收款")
//        let imageText = NSTextAttachment()
//        imageText.image = UIImage(named: "eye")
//        imageText.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
//
//        let imageAtt = NSAttributedString(attachment: imageText)
//
//        alertStr.insert(imageAtt, at: 0)
        
        alertLB = UILabel()
        alertLB.font = Font15
        alertLB.text = "注： 该卡号为默认收款"
        alertLB.textColor = ColorF7931E
        
        addCardBut = UIButton(type: .custom)
        addCardBut.setTitle("添加", for: .normal)
        addCardBut.setTitleColor(ColorFFFFFF, for: .normal)
        addCardBut.backgroundColor = ColorEA5504
        addCardBut.layer.cornerRadius = 5
        addCardBut.addTarget(self, action: #selector(addNewCard(_:)), for: .touchUpInside)
        
        instructions = UITextView()
        instructions.font = Font14
        instructions.textColor = ColorA0A0A0
        instructions.backgroundColor = UIColor.clear
        instructions.isUserInteractionEnabled = false
        instructions.text = """
        温馨提示
        1.建议使用：中国银行 工商银行 招商银行 建设银行卡，提现更快捷；
        2.请务必确保银行卡开户名与实名认证的姓名一致；
        3.请使用储蓄卡作为收款银行卡；
        4.添加银行卡可能会有信息延迟，请耐心等待，如添加未成功请再次添加；
        """
        
        self.view.addSubview(bgView)
        bgView.addSubview(hLine)
        bgView.addSubview(nameTitle)
        bgView.addSubview(nameLB)
        bgView.addSubview(cardNumTF)
        self.view.addSubview(alertLB)
        self.view.addSubview(addCardBut)
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
