//
//  RegisterFooterView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class RegisterFooterView: UIView {

    public var register : UIButton!
    
    private var registerPro : UILabel!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        
        initSubview()
    }
    
    private func initSubview() {
        register = UIButton(type: .custom)
        register.setTitle("注册", for: .normal)
        register.setTitleColor(ColorFFFFFF, for: .normal)
        register.backgroundColor = ColorEA5504
        register.layer.cornerRadius = 5
        
        let attStr = NSMutableAttributedString(string: "注册表明您已同意", attributes: [NSAttributedStringKey.foregroundColor: ColorA0A0A0])
        
        let attProStr = NSAttributedString(string: "《彩小秘彩票服务协议》", attributes: [NSAttributedStringKey.foregroundColor: Color787878])
        attStr.append(attProStr)
        
        
        registerPro = UILabel()
        registerPro.attributedText = attStr
        registerPro.textColor = UIColor.black
        registerPro.font = Font14
        registerPro.textAlignment = .center
        
        self.addSubview(register)
        self.addSubview(registerPro)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        register.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(loginButTopSpacing)
            make.left.equalTo(self).offset(leftSpacing)
            make.right.equalTo(self).offset(-rightSpacing)
            make.height.equalTo(loginButHeight)
        }
        registerPro.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.equalTo(self).offset(leftSpacing)
            make.right.equalTo(self).offset(-rightSpacing)
            make.top.equalTo(register.snp.bottom).offset(12.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
