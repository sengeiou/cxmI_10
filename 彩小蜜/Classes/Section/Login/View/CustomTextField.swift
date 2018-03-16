//
//  CustomTextField.swift
//  彩小蜜
//
//  Created by HX on 2018/3/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

enum CustomTFStyle {
    case mobile
    case password
    case vcode
}

protocol CustomTextFieldDelegate {
    func countdown(button:CountdownButton) -> Void
}

class CustomTextField: UITextField, CountdownButtonDelegate {
    func countdownButClicked(button: CountdownButton) {
        guard customDelegate != nil else { return }
        customDelegate.countdown(button: button)
    }
    
    public var style : CustomTFStyle! {
        didSet{
            guard style != nil else { return }
            switch style {
            case .mobile:
                self.initMobile()
            case .password:
                self.initPassword()
            case .vcode:
                self.initVcode()
            default: break
            }
        }
    }
    
    public var selectImg : String?
    public var customDelegate : CustomTextFieldDelegate!
    
    private var defaultImg : String!
    private var imageView : UIImageView!
    
    init(style : CustomTFStyle, img : String) {
        super.init(frame: CGRect.zero)
        let cusLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 19 + 20 + 7.5, height: 30))
        
        imageView = UIImageView()
        imageView.image = UIImage(named: img)
        self.defaultImg = img
        
        cusLeftView.addSubview(imageView)
        
        self.leftView = cusLeftView
        self.leftViewMode = .always
        
        imageView.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(cusLeftView).offset(19)
            make.width.equalTo(imageView.snp.height)
            make.centerY.equalTo(cusLeftView.snp.centerY)
        }
        
        
        switch style {
        case .mobile:
            self.initMobile()
        case .password:
            self.initPassword()
        case .vcode:
            self.initVcode()
        }
    }
    
    public func changeImg(_ string: String) {
        guard selectImg != nil else { return }
        self.imageView.image = UIImage(named: selectImg!)
        
        guard string == "" else { return }
        guard let length = self.text?.lengthOfBytes(using: .utf8) else { return }
        guard length == 1 else { return }
        
        self.imageView.image = UIImage(named: defaultImg)
    }
    
    private func initMobile() {
        self.clearButtonMode = .whileEditing
    }
    private func initPassword() {
        self.isSecureTextEntry = true
        
        let cusRightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        
        let but = UIButton(type: .custom)
        but.setBackgroundImage(UIImage(named: "hid"), for: .normal)
        but.setBackgroundImage(UIImage(named: "show"), for: .selected)
        but.addTarget(self, action: #selector(eyeButClicked(_:)), for: .touchUpInside)
        cusRightView.addSubview(but)
        
        self.rightView = cusRightView
        self.rightViewMode = .always
        
        but.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.centerY.equalTo(cusRightView.snp.centerY)
            make.right.equalTo(cusRightView).offset(-23.5)
            make.width.equalTo(but.snp.height)
        }
    }
    private func initVcode() {
    
        let cusRightView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: loginTextFieldHeight))
        self.rightView = cusRightView
        self.rightViewMode = .always
        
        let countdownBut = CountdownButton()
        countdownBut.delegate = self
        countdownBut.layer.cornerRadius = 5
        
        let line = UIView()
        line.backgroundColor = ColorEAEAEA
        
        cusRightView.addSubview(line)
        
        cusRightView.addSubview(countdownBut)
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(cusRightView).offset(12.5)
            make.right.equalTo(countdownBut.snp.left).offset(-12)
            make.bottom.equalTo(cusRightView).offset(-12.5)
            make.width.equalTo(1)
        }
        
        countdownBut.snp.makeConstraints { (make) in
            make.top.equalTo(cusRightView).offset(1)
            make.bottom.equalTo(cusRightView).offset(-1)
            make.right.equalTo(cusRightView).offset(-33.5)
            make.width.equalTo(120)
        }
    }
    
    
    @objc private func eyeButClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true {
            self.isSecureTextEntry = false
        }else {
            self.isSecureTextEntry = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



