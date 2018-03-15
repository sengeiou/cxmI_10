//
//  ForgetPswVCodeFooterView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class ForgetPswVCodeFooterView: UIView {

    public var confirm: UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        initSubview()
    }
    
    
    
    private func initSubview() {
        confirm = UIButton(type: .custom)
        confirm.setTitle("确认", for: .normal)
        confirm.setTitleColor(UIColor.white, for: .normal)
        confirm.backgroundColor = UIColor.green
        confirm.layer.cornerRadius = 5
        
        self.addSubview(confirm)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        confirm.snp.makeConstraints { (make) in
            make.height.equalTo(loginButHeight)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
            make.top.equalTo(loginButTopSpacing)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
