//
//  FootballDetailSectionHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/5.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballDetailSectionHeader: UITableViewHeaderFooterView {

    static let identifier = "FootballDetailSectionHeaderId"
    
    public var titleLabel: UILabel!
    
    private var shuLabel: UILabel!
    
    private var bottomLine: UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = ColorFFFFFF
        initSubview()
    }
    
    private func initSubview() {
        shuLabel = UILabel()
        shuLabel.text = "丨"
        shuLabel.textColor = ColorEA5504
        shuLabel.font = Font13
        
        titleLabel = UILabel()
        titleLabel.font = Font13
        titleLabel.textColor = Color9F9F9F
        
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorEAEAEA
        
        self.contentView.addSubview(shuLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(bottomLine)
        
        shuLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(bottomLine.snp.top)
            make.left.equalTo(16 * defaultScale)
            make.width.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(bottomLine.snp.top)
            make.left.equalTo(shuLabel.snp.right).offset(5)
            make.right.equalTo(0)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(1)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
