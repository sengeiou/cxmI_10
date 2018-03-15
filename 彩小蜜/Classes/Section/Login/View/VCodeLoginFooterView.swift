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
        
        self.addSubview(login)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        login.snp.makeConstraints { (make) in
            make.height.equalTo(loginButHeight)
            make.left.equalTo(self).offset(leftSpacing)
            make.right.equalTo(self).offset(-rightSpacing)
            make.top.equalTo(self).offset(loginButTopSpacing)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
