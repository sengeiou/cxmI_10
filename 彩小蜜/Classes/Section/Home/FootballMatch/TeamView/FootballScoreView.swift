//
//  FootballScoreView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/11.
//  Copyright © 2018年 韩笑. All rights reserved.
//  比分，半全场，

import UIKit

protocol FootballScoreViewDelegate {
    
}

class FootballScoreView: UIView {

    
    public var teamInfo : FootballPlayListModel! {
        didSet{
            
        }
    }
    
    public var matchType : FootballMatchType = .比分
    
    public var delegate : FootballScoreViewDelegate!
    
    private var titlelb: UILabel!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
        
        switch matchType {
        case .比分:
            titlelb.text = "点击进行比分投注"
        case .半全场:
            titlelb.text = "点击进行半全场投注"
        default: break
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titlelb.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    private func initSubview() {
        self.layer.borderWidth = 0.3
        self.layer.borderColor = Color9F9F9F.cgColor
        
        titlelb = UILabel()
        titlelb.font = Font12
        titlelb.textColor = Color9F9F9F
        titlelb.textAlignment = .center
        
        self.addSubview(titlelb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
