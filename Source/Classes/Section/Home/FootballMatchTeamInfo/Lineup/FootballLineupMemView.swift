//
//  FootballLineupMemView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit



class FootballLineupMemView: UIView {

    public var memberInfo : FootballLineupMemberInfo! {
        didSet{
            titleLabel.text = memberInfo.personName
            
        }
    }
    
    public var image : String! {
        didSet{
            icon.image = UIImage(named: image)
        }
    }
    
    private var icon : UIImageView!
    private var titleLabel : UILabel!
    
    init() {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
   
    
    private func initSubview() {
        icon = UIImageView()
        //icon.image = UIImage(named: "Hometeam_1")
        
        titleLabel = UILabel()
        titleLabel.font = Font11
        titleLabel.textColor = ColorFFFFFF
        
        
        self.addSubview(icon)
        self.addSubview(titleLabel)
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.centerX.equalTo(self.snp.centerX)
            make.width.height.equalTo(30)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(10)
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
