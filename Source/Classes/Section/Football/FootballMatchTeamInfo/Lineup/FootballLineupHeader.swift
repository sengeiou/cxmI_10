//
//  FootballLineupHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballLineupHeader: UITableViewHeaderFooterView {

    static let identifier : String = "FootballLineupHeader"
    
    public var titleLabel: UILabel!
    public var homeLabel: UILabel!
    public var visiLabel: UILabel!
    
    private var centerLine: UIView!
    
    private var line: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = ColorFFFFFF
        initSubview()
    }
    
    private func initSubview() {
        titleLabel = getLabel()
        titleLabel.textColor = Color505050
        
        homeLabel = getLabel()
        
        visiLabel = getLabel()
        
        centerLine = UIView()
        centerLine.backgroundColor = ColorEAEAEA
        
        line = UIImageView()
        line.image = UIImage(named:"vline")
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(homeLabel)
        self.contentView.addSubview(visiLabel)
        self.contentView.addSubview(centerLine)
        self.contentView.addSubview(line)
        
        centerLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        line.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.top.equalTo(centerLine.snp.bottom)
            make.bottom.equalTo(0)
            make.width.equalTo(1)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(centerLine.snp.top)
            make.left.right.equalTo(0)
        }
        homeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(centerLine.snp.bottom)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(line.snp.left)
        }
        visiLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(homeLabel)
            make.left.equalTo(line.snp.right)
            make.right.equalTo(0)
        }
    }
    
    private func getLabel() -> UILabel {
        let lab = UILabel()
        lab.font = Font13
        lab.textColor = Color9F9F9F
        lab.textAlignment = .center
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
