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
            let titleAtt = NSMutableAttributedString(string: "方案编号: ")
            let title = NSAttributedString(string: schemeInfo.programmeSn, attributes: [NSAttributedStringKey.foregroundColor: Color505050])
            titleAtt.append(title)
            
            sectionTitle.attributedText = titleAtt
            
            
        }
    }
    
    private var sectionTitle : UILabel!
    private var line : UIView!
    private var numTitle : UILabel!
    private var contentTitle : UILabel!
    private var passTitle : UILabel!
    private var multipleTitle : UILabel!
    
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
        numTitle.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(26)
            make.width.equalTo(OrderDetailTitleWidth - 20)
        }
        contentTitle.snp.makeConstraints { (make) in
            make.top.height.equalTo(numTitle)
            make.left.equalTo(numTitle.snp.right).offset(1)
            make.right.equalTo(passTitle.snp.left).offset(-1)
        }
        passTitle.snp.makeConstraints { (make) in
            make.top.height.equalTo(numTitle)
            make.width.equalTo(OrderDetailTitleWidth)
            make.right.equalTo(multipleTitle.snp.left).offset(-1)
        }
        multipleTitle.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(passTitle)
            make.right.equalTo(self.contentView).offset(-26)
        }
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        sectionTitle = UILabel()
        sectionTitle.font = Font19
        sectionTitle.textColor = ColorA0A0A0
        sectionTitle.textAlignment = .left
        sectionTitle.text = "方案编号"
        
        numTitle = getTitleLB("序号")
        numTitle.textAlignment = .left
        contentTitle = getTitleLB("投注内容")
        passTitle = getTitleLB("过关方式")
        multipleTitle = getTitleLB("倍数")
        multipleTitle.textAlignment = .right
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(sectionTitle)
        self.contentView.addSubview(numTitle)
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
