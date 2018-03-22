//
//  CouponCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/22.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {

    private var bgImageView : UIImageView!
    private var moneyLB : UILabel!
    private var titleLB : UILabel!
    private var timeLB : UILabel!
    private var instructions : UILabel!
    private var stateIcon : UIImageView!
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = ColorF4F4F4
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
        }
        moneyLB.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView)
            make.bottom.equalTo(bgImageView.snp.centerY)
            make.left.equalTo(bgImageView).offset(leftSpacing)
            make.width.equalTo(80)
        }
        titleLB.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(moneyLB)
            make.left.equalTo(moneyLB.snp.right).offset(10)
            make.right.equalTo(stateIcon.snp.left).offset(-10)
        }
        stateIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.top.equalTo(bgImageView)
            make.right.equalTo(bgImageView)
        }
        
        timeLB.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.centerY).offset(10)
            make.height.equalTo(20)
            make.left.equalTo(moneyLB)
            make.right.equalTo(bgImageView)
        }
        instructions.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgImageView).offset(-10)
            make.left.right.height.equalTo(timeLB)
        }
        
    }
    
    
    private func initSubview() {
        bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "couponBg")
        
        moneyLB = UILabel()
        moneyLB.text = "100"
        
        
        titleLB = UILabel()
        titleLB.numberOfLines = 0
        titleLB.text = "购彩满1000减50元，不限彩种"
        
        timeLB = UILabel()
        timeLB.text = "有效期: 剩余7天"
    
        instructions = UILabel()
        instructions.text = "使用说明： 订单金额满1000元可减免50元"
        
        stateIcon = UIImageView()
        stateIcon.image = UIImage(named: "Expired")
        
        
        self.contentView.addSubview(bgImageView)
        bgImageView.addSubview(moneyLB)
        bgImageView.addSubview(titleLB)
        bgImageView.addSubview(timeLB)
        bgImageView.addSubview(instructions)
        bgImageView.addSubview(stateIcon)
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
