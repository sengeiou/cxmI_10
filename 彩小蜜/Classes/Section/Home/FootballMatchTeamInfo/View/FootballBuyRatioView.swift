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
        vline.snp.makeConstraints { (make) in
            make.top.equalTo(5 * defaultScale)
            make.bottom.equalTo(-5 * defaultScale)
            make.width.equalTo(1)
            make.left.equalTo(homelb.snp.right)
        }
        vlineOne.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(vline)
            make.left.equalTo(flatlb.snp.right)
        }
    }
    
    private func initSubview() {
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorC8C8C8.cgColor
        
        homelb = getLabel()
        flatlb = getLabel()
        visilb = getLabel()
        
        vline = UIView()
        vline.backgroundColor = ColorC8C8C8
        
        vlineOne = UIView()
        vlineOne.backgroundColor = ColorC8C8C8
        
        self.addSubview(homelb)
        self.addSubview(flatlb)
        self.addSubview(visilb)
        self.addSubview(vline)
        self.addSubview(vlineOne)
        
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.textColor = Color787878
        lab.font = Font13
        lab.textAlignment = .center
        lab.text = "77%"
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
