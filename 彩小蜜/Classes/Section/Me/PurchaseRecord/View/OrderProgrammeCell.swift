//
//  OrderProgrammeCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class OrderProgrammeCell: UITableViewCell {

    private var programmeNo : UILabel! //方案编号
    private var creatTime : UILabel!  // 创建时间
    private var orderTime : UILabel!  // 接单时间
    private var ticketTime : UILabel! // 出票时间
    
    private var sectionTitle : UILabel!
    private var detailLB : UILabel!
    private var detailIcon : UIImageView!
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
            make.width.equalTo(100)
        }
        
        detailLB.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(sectionTitle)
            make.left.equalTo(sectionTitle.snp.right).offset(1)
            make.right.equalTo(detailIcon.snp.left).offset(-5)
        }
        detailIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(detailLB.snp.centerY)
            make.width.height.equalTo(20)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
        }
        
        programmeNo.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.height.equalTo(creatTime)
        }
        creatTime.snp.makeConstraints { (make) in
            make.top.equalTo(programmeNo.snp.bottom).offset(1)
            make.left.right.height.equalTo(programmeNo)
        }
        orderTime.snp.makeConstraints { (make) in
            make.top.equalTo(creatTime.snp.bottom).offset(1)
            make.left.right.height.equalTo(programmeNo)
        }
        ticketTime.snp.makeConstraints { (make) in
            make.top.equalTo(orderTime.snp.bottom).offset(1)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.left.right.height.equalTo(programmeNo)
        }
    }
    
    private func initSubview() {
        
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        sectionTitle = UILabel()
        sectionTitle.font = Font17
        sectionTitle.textColor = ColorA0A0A0
        sectionTitle.textAlignment = .left
        sectionTitle.text = "方案信息"
        
        detailLB = UILabel()
        detailLB.font = Font17
        detailLB.textColor = Color505050
        detailLB.textAlignment = .right
        detailLB.text = "查看出票方案"
        
        detailIcon = UIImageView()
        detailIcon.image = UIImage(named: "jump")
        
        programmeNo = getLB()
        creatTime = getLB()
        orderTime = getLB()
        ticketTime = getLB()
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(sectionTitle)
        self.contentView.addSubview(detailLB)
        self.contentView.addSubview(detailIcon)
        self.contentView.addSubview(programmeNo)
        self.contentView.addSubview(creatTime)
        self.contentView.addSubview(orderTime)
        self.contentView.addSubview(ticketTime)
        
    }
    
    private func getLB() -> UILabel {
        let lab = UILabel()
        lab.font = Font15
        lab.textColor = ColorA0A0A0
        lab.textAlignment = .left
        lab.text = "方案编号： 10514545661466561498"
        
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
