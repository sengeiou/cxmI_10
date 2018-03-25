//
//  OrderDetailTitleCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

let OrderDetailTitleWidth : CGFloat = 60

class OrderDetailTitleCell: UITableViewCell {

    private var timeTitle : UILabel!
    private var timeLB : UILabel!
    private var nameTitle: UILabel!
    private var nameLB : UILabel!
    private var vsLB : UILabel!
    private var nameTwoLB: UILabel!
    private var ruleTitle: UILabel!
    private var ruleLB : UILabel!
    private var recordTitle: UILabel!
    private var recordLB: UILabel!
    private var resultTitle: UILabel!
    private var resultLB : UILabel!
    
    private var sectionTitle : UILabel!
    private var line : UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(40)
            make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
            make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        sectionTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(1)
            make.bottom.equalTo(line.snp.top).offset(-1)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
        }
        
        timeTitle.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.width.equalTo(OrderDetailTitleWidth)
            make.height.equalTo(15)
        }
        nameTitle.snp.makeConstraints { (make) in
            make.top.height.equalTo(timeTitle)
            make.left.equalTo(timeTitle.snp.right).offset(1)
            make.right.equalTo(ruleTitle.snp.left).offset(-1)
        }
        ruleTitle.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(timeTitle)
            make.right.equalTo(recordTitle.snp.left).offset(-1)
        }
        recordTitle.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(timeTitle)
            make.right.equalTo(resultTitle.snp.left).offset(-1)
        }
        resultTitle.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(timeTitle)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
        }
        
        
        timeLB.snp.makeConstraints { (make) in
            make.top.equalTo(timeTitle.snp.bottom).offset(5)
            make.bottom.equalTo(self.contentView).offset(-5)
            make.width.equalTo(timeTitle)
            make.left.equalTo(self.contentView).offset(leftSpacing)
        }
        nameLB.snp.makeConstraints { (make) in
            make.top.equalTo(timeLB)
            make.left.equalTo(timeLB.snp.right).offset(1)
            make.right.equalTo(ruleLB.snp.left).offset(-1)
        }
        vsLB.snp.makeConstraints { (make) in
            make.top.equalTo(nameLB.snp.bottom).offset(1)
            make.left.width.height.equalTo(nameLB)
        }
        nameTwoLB.snp.makeConstraints { (make) in
            make.top.equalTo(vsLB.snp.bottom)
            make.left.height.width.equalTo(nameLB)
            make.bottom.equalTo(timeLB)
        }

        ruleLB.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(timeLB)
            make.right.equalTo(recordLB.snp.left).offset(-1)
        }

        recordLB.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(timeLB)
            make.right.equalTo(resultLB.snp.left).offset(-1)
        }

        resultLB.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(timeLB)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
        }
        
    }
    
    private func initSubview() {
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        sectionTitle = UILabel()
        sectionTitle.font = Font17
        sectionTitle.textColor = ColorA0A0A0
        sectionTitle.textAlignment = .left
        sectionTitle.text = "方案内容"
        
        timeTitle = getTitleLB("场次")
        timeTitle.textAlignment = .left
        nameTitle = getTitleLB("赛事")
        ruleTitle = getTitleLB("玩法")
        recordTitle = getTitleLB("投注")
        resultTitle = getTitleLB("赛果")
        resultTitle.textAlignment = .right
        
        timeLB = getDetailLB()
        timeLB.textAlignment = .left
        nameLB = getDetailLB()
        vsLB = getDetailLB()
        vsLB.text = "VS"
        vsLB.textAlignment = .center
        nameTwoLB = getDetailLB()
        ruleLB = getDetailLB()
        recordLB = getDetailLB()
        resultLB = getDetailLB()
        resultLB.textAlignment = .right
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(sectionTitle)
        self.contentView.addSubview(timeTitle)
        self.contentView.addSubview(nameTitle)
        self.contentView.addSubview(ruleTitle)
        self.contentView.addSubview(recordTitle)
        self.contentView.addSubview(resultTitle)
        
        self.contentView.addSubview(timeLB)
        self.contentView.addSubview(nameLB)
        self.contentView.addSubview(vsLB)
        self.contentView.addSubview(nameTwoLB)
        self.contentView.addSubview(ruleLB)
        self.contentView.addSubview(recordLB)
        self.contentView.addSubview(resultLB)
        
    }
    
    private func getTitleLB(_ text: String) -> UILabel {
        let lab = UILabel()
        lab.font = Font15
        lab.text = text
        lab.textColor = ColorA0A0A0
        lab.textAlignment = .center
        return lab
    }
    
    private func getDetailLB() -> UILabel {
        let lab = UILabel()
        lab.font = Font15
        lab.text = "周一"
        lab.textColor = Color505050
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
