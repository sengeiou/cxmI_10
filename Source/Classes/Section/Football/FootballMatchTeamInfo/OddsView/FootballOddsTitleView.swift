//
//  FootballOddsTitleView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballOddsTitleView: UIView {

    public var homelb : UILabel!
    public var flatlb : UILabel!
    public var visilb : UILabel!
    
    private var company : UILabel!
    
    private var bottomLine : UIView!
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        company.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(bottomLine.snp.top)
            make.left.equalTo(5 * defaultScale)
            make.width.equalTo(72 * defaultScale)
        }
        homelb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(company)
            make.width.equalTo(40 * defaultScale)
            make.left.equalTo(company.snp.right).offset(80 * defaultScale)
        }
        flatlb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(company)
            make.left.equalTo(homelb.snp.right)
            make.right.equalTo(visilb.snp.left)
        }
        visilb.snp.makeConstraints { (make) in
            make.width.equalTo(homelb)
            make.right.equalTo(-16 * defaultScale)
            make.top.bottom.equalTo(company)
        }
    }
    
    private func initSubview() {
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorC8C8C8
        
        company = getLabel("公司")
        homelb = getLabel("胜")
        flatlb = getLabel("平")
        visilb = getLabel("负")
        
        self.addSubview(bottomLine)
        self.addSubview(company)
        self.addSubview(homelb)
        self.addSubview(flatlb)
        self.addSubview(visilb)
    }
    private func getLabel(_ title : String) -> UILabel {
        let lab = UILabel()
        lab.text = title
        lab.font = Font12
        lab.textColor = Color9F9F9F
        lab.textAlignment = .center
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
