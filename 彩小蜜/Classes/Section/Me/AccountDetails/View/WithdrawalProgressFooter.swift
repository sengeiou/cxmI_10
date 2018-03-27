//
//  WithdrawalProgressFooter.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class WithdrawalProgressFooter: UIView {

    private var titleLB: UILabel!
    private var detailLB: UILabel!
    private var line : UIView!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 90))
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        line.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(SeparatorLeftSpacing)
            make.right.equalTo(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.left.equalTo(leftSpacing)
            make.width.equalTo(60)
            make.bottom.equalTo(10)
        }
        detailLB.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(titleLB)
            make.left.equalTo(titleLB.snp.right).offset(10)
            make.right.equalTo(-10)
            
        }
    }
    
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        titleLB = UILabel()
        titleLB.font = Font19
        titleLB.textColor = Color505050
        titleLB.textAlignment = .center
        titleLB.text = "提取到"
        
        detailLB = UILabel()
        detailLB.font = Font13
        detailLB.textColor = ColorA0A0A0
        detailLB.textAlignment = .right
        detailLB.text = "招商银行（尾号1234）"
        
        self.addSubview(line)
        self.addSubview(titleLB)
        self.addSubview(detailLB)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
