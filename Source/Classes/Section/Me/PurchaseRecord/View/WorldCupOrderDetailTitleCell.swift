//
//  WorldCupOrderDetailTitleCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class WorldCupOrderDetailTitleCell: UITableViewCell {

    public var detailType : String! {
        didSet{
            guard detailType != nil else { return }
            if detailType == "1" {
                nameTitle.text = "猜冠军球队"
            }else if detailType == "2" {
                nameTitle.text = "猜冠亚军球队"
            }
        }
    }
    
    private var nameTitle: UILabel!
    private var oddTitle: UILabel!      // 玩法
    private var resultTitle: UILabel!    // 赛果
    
    private var sectionTitle : UILabel!
    private var line : UIView!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        sectionTitle = UILabel()
        sectionTitle.font = Font14
        sectionTitle.textColor = ColorA0A0A0
        sectionTitle.textAlignment = .left
        sectionTitle.text = "方案内容"
        nameTitle = getTitleLB("猜冠军球队")
        oddTitle = getTitleLB("赔率")
        resultTitle = getTitleLB("赛果")
        //resultTitle.textAlignment = .right
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(sectionTitle)
        self.contentView.addSubview(nameTitle)
        self.contentView.addSubview(oddTitle)
        self.contentView.addSubview(resultTitle)
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(orderSectionHeaderHeight)
            make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
            make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        sectionTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(11)
            make.bottom.equalTo(line.snp.top).offset(-11)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
        }
        nameTitle.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(11)
            make.left.equalTo(self.contentView).offset(16)
            make.width.equalTo(resultTitle)
            make.bottom.equalTo(-11)
        }
        oddTitle.snp.makeConstraints { (make) in
            make.top.height.equalTo(nameTitle)
            make.width.equalTo(80)
            make.left.equalTo(nameTitle.snp.right).offset(1)
            make.right.equalTo(resultTitle.snp.left).offset(-1)
        }
        resultTitle.snp.makeConstraints { (make) in
            make.top.height.equalTo(nameTitle)
            make.right.equalTo(self.contentView).offset(-5)
        }
    }
    
    private func getTitleLB(_ text: String) -> UILabel {
        let lab = UILabel()
        lab.font = Font12
        lab.text = text
        lab.textColor = ColorA0A0A0
        
        lab.textAlignment = .center
        return lab
    }
    
    private func getDetailLB() -> UILabel {
        let lab = UILabel()
        lab.font = Font12
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
