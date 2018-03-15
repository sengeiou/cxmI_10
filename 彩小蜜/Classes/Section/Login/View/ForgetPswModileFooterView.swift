//
//  ForgetPswModileFooterView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/15.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class ForgetPswModileFooterView: UIView {

    public var nextBut : UIButton!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        initSubview()
    }
    
    private func initSubview() {
        nextBut = UIButton(type: .custom)
        nextBut.setTitle("下一步", for: .normal)
        nextBut.setTitleColor(ColorFFFFFF, for: .normal)
        nextBut.backgroundColor = ColorEA5504
        nextBut.layer.cornerRadius = 5
        
        self.addSubview(nextBut)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nextBut.snp.makeConstraints { (make) in
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
