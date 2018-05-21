//
//  VCodeLoginFooterView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class VCodeLoginFooterView: UIView {

    public var login : UIButton!
    public var register : UIButton!
    public var pswLogin : UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        initSubview()
    }
    
    private func initSubview() {
        login = UIButton(type: .custom)
        login.setTitle("登录", for: .normal)
        login.setTitleColor(ColorFFFFFF, for: .normal)
        login.backgroundColor = ColorEA5504
        login.layer.cornerRadius = 5
        
        pswLogin = UIButton(type: .custom)
        pswLogin.setTitle("密码登录", for: .normal)
        pswLogin.titleLabel?.font = Font14
        pswLogin.setTitleColor(Color787878, for: .normal)
        pswLogin.backgroundColor = UIColor.clear
        pswLogin.contentHorizontalAlignment = .left
        
        register = UIButton(type: .custom)
        register.setTitle("新用户注册", for: .normal)
        register.setTitleColor(ColorEA5504, for: .normal)
        register.backgroundColor = UIColor.white
        register.layer.cornerRadius = 5
        register.layer.borderWidth = 0.5
        register.layer.borderColor = ColorEA5504.cgColor
        
        self.addSubview(login)
        self.addSubview(pswLogin)
        self.addSubview(register)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        login.snp.makeConstraints { (make) in
            make.height.equalTo(loginButHeight)
            make.left.equalTo(self).offset(leftSpacing)
            make.right.equalTo(self).offset(-rightSpacing)
            make.top.equalTo(self).offset(loginButTopSpacing)
        }
        
        register.snp.makeConstraints { (make) in
            make.height.equalTo(loginButHeight)
            make.left.equalTo(self).offset(leftSpacing)
            make.right.equalTo(self).offset(-rightSpacing)
            make.top.equalTo(login.snp.bottom).offset(12.5)
        }
        
        pswLogin.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.equalTo(login)
            make.width.equalTo(200)
            make.top.equalTo(register.snp.bottom).offset(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
