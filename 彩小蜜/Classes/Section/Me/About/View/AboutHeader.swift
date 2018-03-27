//
//  AboutHeader.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class AboutHeader: UIView {

    private var icon : UIImageView!
    private var versionLB: UILabel!
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 150))
        
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.width.equalTo(80)
            make.height.equalTo(50)
            make.centerX.equalTo(self.snp.centerX)
        }
        versionLB.snp.makeConstraints { (make) in
            make.bottom.equalTo(icon.snp.bottom)
            make.width.equalTo(60)
            make.height.equalTo(12)
            make.left.equalTo(icon.snp.right).offset(2)
        }
    }
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        icon = UIImageView()
        icon.image = UIImage(named: "recording")
        
        versionLB = UILabel()
        versionLB.font = Font10
        versionLB.textColor = ColorEA5504
        versionLB.textAlignment = .left
        
        self.addSubview(icon)
        self.addSubview(versionLB)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
