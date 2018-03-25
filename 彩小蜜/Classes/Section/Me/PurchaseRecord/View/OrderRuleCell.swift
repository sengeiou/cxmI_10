//
//  OrderRuleCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class OrderRuleCell: UITableViewCell {

    private var title : UILabel!
    private var detail : UILabel!
    private var line : UIView!
    
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
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.left.equalTo(self.contentView).offset(leftSpacing)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
        }
        detail.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.height.left.right.equalTo(title)
        }
    }
    
    private func initSubview() {
        line = UIView()
        line.backgroundColor = ColorF4F4F4
        
        title = UILabel()
        title.font = Font15
        title.textColor = Color505050
        title.textAlignment = .left
        title.text = "过关方式： 2串1 3串1"
        
        detail = UILabel()
        detail.font = Font15
        detail.textColor = Color505050
        detail.textAlignment = .left
        detail.text = "4注2倍"
        
        self.contentView.addSubview(line)
        self.contentView.addSubview(title)
        self.contentView.addSubview(detail)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
