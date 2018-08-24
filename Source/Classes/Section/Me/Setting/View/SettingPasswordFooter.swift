//
//  SettingPasswordFooter.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class SettingPasswordFooter: UIView {

    public var confirmBut : UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        initSubview()
    }
    
    private func initSubview() {
        confirmBut = UIButton(type: .custom)
        confirmBut.setTitleColor(ColorFFFFFF, for: .normal)
        confirmBut.layer.cornerRadius = 5
        confirmBut.backgroundColor = ColorEA5504
        
        self.addSubview(confirmBut)
        
        confirmBut.snp.makeConstraints { (make) in
            make.top.equalTo(30 * defaultScale)
            make.left.equalTo(16 * defaultScale)
            make.right.equalTo(-16 * defaultScale)
            make.height.equalTo(44 * defaultScale)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
