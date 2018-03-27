//
//  AboutFooter.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class AboutFooter: UIView {

    private var serviceLB : UILabel!
    private var webLB: UILabel!
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 300))
        
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        serviceLB.snp.makeConstraints { (make) in
            make.top.equalTo(150)
            make.left.equalTo(80)
            make.right.equalTo(-rightSpacing)
            make.height.equalTo(20)
        }
        webLB.snp.makeConstraints { (make) in
            make.top.equalTo(serviceLB.snp.bottom).offset(1)
            make.left.right.height.equalTo(serviceLB)
        }
    }
    private func initSubview() {
        serviceLB = UILabel()
        serviceLB.font = Font10
        serviceLB.textColor = ColorEA5504
        serviceLB.textAlignment = .left
        serviceLB.text = "客服热线： 400-000-1234"
        
        webLB = UILabel()
        webLB.font = Font10
        webLB.textColor = ColorEA5504
        webLB.textAlignment = .left
        webLB.text = "官网： http://www.caixiaomi.com"
        
        self.addSubview(serviceLB)
        self.addSubview(webLB)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
