//
//  CustomTextField.swift
//  彩小蜜
//
//  Created by HX on 2018/3/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    public var isPassword: Bool? {
        didSet{
            if isPassword == true {
                initEyeBut()
            }
        }
    }
    
    init(imageName : String) {
        super.init(frame: CGRect.zero)
        
        let cusLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        imageView.image = UIImage(named: imageName)
        
        cusLeftView.addSubview(imageView)
        
        self.leftView = cusLeftView
        self.leftViewMode = .always
    }
    
    func initEyeBut() {
        self.isSecureTextEntry = true
        
        let cusRightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        
        let but = UIButton(type: .custom)
        but.setBackgroundImage(UIImage(named: "userID"), for: .normal)
        but.setBackgroundImage(UIImage(named: "eye"), for: .selected)
        but.addTarget(self, action: #selector(eyeButClicked(_:)), for: .touchUpInside)
        
        self.rightView = cusRightView
        self.rightViewMode = .always
        
        cusRightView.addSubview(but)
        
        but.snp.makeConstraints { (make) in
            make.top.equalTo(cusRightView).offset(5)
            make.bottom.equalTo(cusRightView).offset(-5)
            make.right.equalTo(cusRightView).offset(-5)
            make.width.equalTo(but.snp.height)
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
