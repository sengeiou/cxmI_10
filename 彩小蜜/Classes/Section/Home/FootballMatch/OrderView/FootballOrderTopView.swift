//
//  FootballOrderTopView.swift
//  彩小蜜
//
//  Created by HX on 2018/4/3.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballOrderTopView: UIView {

    public var number : String = "0" {
        didSet{
            titleLB.text = "共有\(number)场比赛可投"
        }
    }
    
    private var titleLB: UILabel!
    private var bgView: UIView!
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44 * defaultScale))
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        titleLB.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
        }
    }
    private func initSubview() {
        self.backgroundColor = ColorF4F4F4
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        titleLB = UILabel()
        titleLB.font = Font14
        titleLB.textColor = Color787878
        titleLB.textAlignment = .left
        titleLB.text = "共有\(number)场比赛可投"
        
        bgView.addSubview(titleLB)
        self.addSubview(bgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
