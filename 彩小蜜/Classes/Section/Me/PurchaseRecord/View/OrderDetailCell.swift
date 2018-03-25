//
//  OrderDetailCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class OrderDetailCell: UITableViewCell {


    private var timeLB : UILabel!
    private var nameLB : UILabel!
    private var vsLB : UILabel!
    private var nameTwoLB: UILabel!
    private var ruleLB : UILabel!
    private var recordLB: UILabel!
    private var resultLB : UILabel!
    private var line : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(0)
            make.left.equalTo(self.contentView).offset(SeparatorLeftSpacing)
            make.right.equalTo(self.contentView).offset(-SeparatorLeftSpacing)
            make.height.equalTo(SeparationLineHeight)
        }
        
        timeLB.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(5)
            make.bottom.equalTo(self.contentView).offset(-5)
            make.width.equalTo(OrderDetailTitleWidth)
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
        line = UIImageView()
        line.image = UIImage(named:"line")
        
        timeLB = getDetailLB()
        timeLB.textAlignment = .left
        nameLB = getDetailLB()
        vsLB = getDetailLB()
        nameTwoLB = getDetailLB()
        ruleLB = getDetailLB()
        recordLB = getDetailLB()
        resultLB = getDetailLB()
        resultLB.textAlignment = .right
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(timeLB)
        self.contentView.addSubview(nameLB)
        self.contentView.addSubview(vsLB)
        self.contentView.addSubview(nameTwoLB)
        self.contentView.addSubview(ruleLB)
        self.contentView.addSubview(recordLB)
        self.contentView.addSubview(resultLB)
        
    }
    
    private func getDetailLB() -> UILabel {
        let lab = UILabel()
        lab.font = Font15
        lab.text = "白塞"
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
