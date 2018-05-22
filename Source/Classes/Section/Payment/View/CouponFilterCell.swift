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
            let moneyAtt = NSMutableAttributedString(string: "¥ ")
            let money = NSAttributedString(string: bonusInfo.bonusPrice, attributes: [NSAttributedStringKey.font: Font24])
            moneyAtt.append(money)
            
            moneylb.attributedText = moneyAtt
            
            contentlb.text = bonusInfo.useRange
            
            titleLb.text = bonusInfo.minGoodsAmount
           
            changeIcon(isSelected: bonusInfo.isSelected)
            
        }
    }
    
    private func changeIcon (isSelected: Bool) {
        if isSelected == true {
            selectedIcon.image = UIImage(named: "Mentionmoneysteps_sel")
        }else {
            selectedIcon.image = UIImage(named: "Mentionmoneysteps_nor")
        }
    }
    
    private var titleLb : UILabel!
    private var moneylb : UILabel!
    private var contentlb : UILabel!
    private var selectedIcon : UIImageView!
    
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
        titleLb.textAlignment = .center
        
        moneylb = UILabel()
        moneylb.font = Font16
        moneylb.textColor = ColorEA5504
        moneylb.textAlignment = .left
        
        contentlb = UILabel()
        contentlb.font = Font13
        contentlb.textColor = Color505050
        contentlb.textAlignment = .center
        
        selectedIcon = UIImageView()
        selectedIcon.image = UIImage(named: "Mentionmoneysteps_nor")
        
        self.contentView.addSubview(titleLb)
        self.contentView.addSubview(moneylb)
        self.contentView.addSubview(contentlb)
        self.contentView.addSubview(selectedIcon)
        
        titleLb.snp.makeConstraints { (make) in
            make.top.equalTo(15 * defaultScale)
            make.left.right.equalTo(contentlb)
            make.height.equalTo(contentlb)
        }
        
        moneylb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(16 * defaultScale)
            make.width.equalTo(137 * defaultScale)
        }
        contentlb.snp.makeConstraints { (make) in
            make.top.equalTo(titleLb.snp.bottom).offset(5)
            make.bottom.equalTo(-15 * defaultScale)
            make.left.equalTo(moneylb.snp.right)
            make.right.equalTo(selectedIcon.snp.left).offset(-15 * defaultScale)
        }
        selectedIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(14 * defaultScale)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(-16 * defaultScale)
        }
    }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}