//
//  FootballTopView.swift
//  彩小蜜
//
//  Created by HX on 2018/3/29.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballTopView: UIView {

    public var number : String = "0" {
        didSet{
            titleLB.text = "共有\(number)场比赛可投注"
        }
    }
    
    private var titleLB: UILabel!
    private var bgView: UIView!
    private var line : UIView!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 36 * defaultScale))
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(0.5)
            make.left.right.equalTo(0)
        }
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(line.snp.top)
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
        
        line = UIView()
        line.backgroundColor = ColorE9E9E9
        
        bgView = UIView()
        bgView.backgroundColor = ColorFFFFFF
        
        titleLB = UILabel()
        titleLB.font = Font14
        titleLB.textColor = Color9F9F9F
        titleLB.textAlignment = .left
        titleLB.text = "共有\(number)场比赛可投注"
        
        bgView.addSubview(titleLB)
        self.addSubview(bgView)
        self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
