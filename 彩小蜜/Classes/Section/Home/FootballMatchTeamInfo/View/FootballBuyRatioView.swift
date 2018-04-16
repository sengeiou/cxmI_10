//
//  FootballBuyRatioView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/16.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballBuyRatioView: UIView {

    private var homelb : UILabel!
    private var flatlb : UILabel!
    private var visilb : UILabel!
    
    private var vline : UIView!
    private var vlineOne : UIView!
    
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        homelb.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(flatlb)
        }
        flatlb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(homelb)
            make.left.equalTo(homelb.snp.right).offset(1)
            make.width.equalTo(visilb)
        }
        visilb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(homelb)
            make.left.equalTo(flatlb.snp.right).offset(1)
            make.right.equalTo(0)
        }
    }
    
    private func initSubview() {
        //homelb =
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
