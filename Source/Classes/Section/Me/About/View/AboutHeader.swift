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
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 192 * defaultScale))
        
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(49 * defaultScale)
            make.width.equalTo(124 * defaultScale)
            make.height.equalTo(40 * defaultScale)
            make.centerX.equalTo(self.snp.centerX).offset(-10)
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
        icon.image = UIImage(named: "logo")
        
        versionLB = UILabel()
        versionLB.font = Font12
        versionLB.textColor = ColorEA5504
        versionLB.textAlignment = .left
        versionLB.text = "v" + DeviceManager.share.device.appv
        
        self.addSubview(icon)
        self.addSubview(versionLB)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
