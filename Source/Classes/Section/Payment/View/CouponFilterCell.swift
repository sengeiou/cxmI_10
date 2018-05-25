//
//  CouponFilterCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/11.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class CouponFilterCell: UITableViewCell {

    public var bonusInfo : BonusInfoModel! {
        didSet{
            guard bonusInfo != nil else { return }
            
            let moneyAtt = NSMutableAttributedString(string: "")
            let moneyAt = NSAttributedString(string: "¥ ")
            var money : NSAttributedString!
            var endTitle = ""
            if bonusInfo.bonusPrice != "不使用优惠券" {
                moneyAtt.append(moneyAt)
                money = NSAttributedString(string: bonusInfo.bonusPrice, attributes: [NSAttributedStringKey.font: Font24])
                endTitle = "有效期至"
            }else {
                money = NSAttributedString(string: bonusInfo.bonusPrice, attributes: [NSAttributedStringKey.font: Font15])
            }
            moneyAtt.append(money)
            
            moneylb.attributedText = moneyAtt
            
            contentlb.text = bonusInfo.useRange
            
            titleLb.text = bonusInfo.minGoodsAmount
            
            let overdueAtt = NSMutableAttributedString(string: "\(bonusInfo.leaveTime) ", attributes: [NSAttributedStringKey.foregroundColor: ColorEA5504])
            
            let time = NSAttributedString(string:"\(endTitle) \(bonusInfo.bonusEndTime)", attributes: [NSAttributedStringKey.foregroundColor: ColorC8C8C8])
            overdueAtt.append(time)
            overdueLb.attributedText = overdueAtt
            
            
            //changeIcon(isSelected: bonusInfo.isSelected)
            
        }
    }
    
    private func changeIcon (isSelected: Bool) {
        if isSelected == true {
            selectedIcon.image = UIImage(named: "Mentionmoneysteps_sel")
        }else {
            selectedIcon.image = UIImage(named: "Mentionmoneysteps_nor")
        }
    }
    
    private var titleLb : UILabel!    //
    private var moneylb : UILabel!    // 金额
    private var contentlb : UILabel!  // 红包使用限制
    private var selectedIcon : UIImageView!
    private var overdueLb : UILabel!  // 剩余过期时间
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    // MARK: - 初始化
    private func initSubview() {
        self.selectionStyle = .none
        
        titleLb = UILabel()
        titleLb.font = Font13
        titleLb.textColor = Color505050
        titleLb.textAlignment = .left
        
        moneylb = UILabel()
        moneylb.font = Font16
        moneylb.textColor = ColorEA5504
        moneylb.textAlignment = .left
        
        contentlb = UILabel()
        contentlb.font = Font13
        contentlb.textColor = Color505050
        contentlb.textAlignment = .left
        
        overdueLb = UILabel()
        overdueLb.font = Font11
        overdueLb.textColor = ColorC8C8C8
        overdueLb.textAlignment = .left
        overdueLb.text = "5天后过期，有效期至2018/07/09"
        
        selectedIcon = UIImageView()
        selectedIcon.image = UIImage(named: "Mentionmoneysteps_nor")
        
        self.contentView.addSubview(titleLb)
        self.contentView.addSubview(moneylb)
        self.contentView.addSubview(contentlb)
        self.contentView.addSubview(selectedIcon)
        self.contentView.addSubview(overdueLb)
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(15 * defaultScale)
            make.left.right.equalTo(contentlb)
            make.height.equalTo(contentlb)
        }
        
        moneylb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb)
            make.height.equalTo(24)
            make.left.equalTo(16 * defaultScale)
            make.width.equalTo(100 * defaultScale)
        }
        contentlb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(5)
            //make.bottom.equalTo(-15 * defaultScale)
            make.height.equalTo(overdueLb)
            make.left.equalTo(moneylb.snp.right)
            make.right.equalTo(selectedIcon.snp.left).offset(-15 * defaultScale)
        }
        overdueLb.snp.makeConstraints { (make) in
            make.top.equalTo(contentlb.snp.bottom).offset(5)
            make.bottom.equalTo(-15 * defaultScale)
            make.left.right.equalTo(contentlb)
        }
        selectedIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(14 * defaultScale)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(-16 * defaultScale)
        }
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            selectedIcon.image = UIImage(named: "Mentionmoneysteps_sel")
        }else {
            selectedIcon.image = UIImage(named: "Mentionmoneysteps_nor")
        }
        guard bonusInfo != nil else { return }
        bonusInfo.isSelected = selected
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
