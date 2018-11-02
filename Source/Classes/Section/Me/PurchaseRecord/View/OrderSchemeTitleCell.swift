//
//  OrderSchemeTitleCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class OrderSchemeTitleCell: UITableViewCell {

    public var schemeInfo: OrderSchemeInfoModel! {
        didSet{
            guard schemeInfo != nil else { return }
            let titleAtt = NSMutableAttributedString(string: "模拟编号: ")
            let title = NSAttributedString(string: schemeInfo.programmeSn, attributes: [NSAttributedStringKey.foregroundColor: Color505050])
            titleAtt.append(title)
            
            sectionTitle.attributedText = titleAtt
        }
    }
    
    private var sectionTitle : UILabel!
    private var line : UIView!
    //private var numTitle : UILabel!
    private var contentTitle : UILabel!
    private var passTitle : UILabel!
    private var multipleTitle : UILabel!
    private var orderState : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(orderSectionHeaderHeight)
            make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
            make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        sectionTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(5)
            make.bottom.equalTo(line.snp.top).offset(-5)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
        }

        contentTitle.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(26)
            make.right.equalTo(passTitle.snp.left).offset(-1)
        }
        passTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentTitle.snp.centerY)
            make.width.equalTo(OrderDetailTitleWidth)
            make.right.equalTo(multipleTitle.snp.left).offset(-15)
        }
        multipleTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentTitle.snp.centerY)
            make.height.width.equalTo(passTitle)
            make.width.equalTo(OrderDetailTitleWidth - 14 )
            make.right.equalTo(orderState.snp.left).offset(-5)
        }
        orderState.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(passTitle)
            make.left.equalTo(multipleTitle.snp.right)
            make.right.equalTo(self.contentView).offset(-26 * defaultScale)
        }
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        sectionTitle = UILabel()
        sectionTitle.font = Font13
        sectionTitle.textColor = ColorA0A0A0
        sectionTitle.textAlignment = .left
        sectionTitle.text = "模拟编号"
        
//        numTitle = getTitleLB("序号")
//        numTitle.textAlignment = .left
        contentTitle = getTitleLB("投注内容")
        passTitle = getTitleLB("过关方式")
        multipleTitle = getTitleLB("倍数")
        //multipleTitle.textAlignment = .right
        
        orderState = getTitleLB("状态")
        orderState.textAlignment = .right
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(sectionTitle)
        self.contentView.addSubview(orderState)
        self.contentView.addSubview(contentTitle)
        self.contentView.addSubview(passTitle)
        self.contentView.addSubview(multipleTitle)
    }

    private func getTitleLB(_ text: String) -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.text = text
        lab.textColor = ColorA0A0A0
        lab.textAlignment = .center
        return lab
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
