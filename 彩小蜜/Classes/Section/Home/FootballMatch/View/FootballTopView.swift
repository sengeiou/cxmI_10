//
//  FootballTopView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballTopView: UIView {

    private var titleLB: UILabel!
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44 * defaultScale))
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLB.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
        }
    }
    private func initSubview() {
        self.backgroundColor = ColorFFFFFF
        titleLB = UILabel()
        titleLB.font = Font14
        titleLB.textColor = Color787878
        titleLB.textAlignment = .left
        titleLB.text = "共有********场比赛可投"
        
        self.addSubview(titleLB)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
