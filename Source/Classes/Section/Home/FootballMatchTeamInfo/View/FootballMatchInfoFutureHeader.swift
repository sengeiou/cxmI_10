//
//  FootballMatchInfoFutureHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballMatchInfoFutureHeader: UITableViewHeaderFooterView {

    static let identifier: String = "FootballMatchInfoFutureHeader"
    
    public var teamName: UILabel!
    
    private var titleLabel: UILabel!
    
    private var hLine: UIView!
    
    private var teamLabel: UILabel!
    private var dateLabel: UILabel!
    private var homeLabel: UILabel!
    private var visiLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = ColorFFFFFF
        initSubview()
    }
    
    private func initSubview() {
        hLine = UIView()
        hLine.backgroundColor = ColorEAEAEA
        
        titleLabel = getLabel()
        titleLabel.textAlignment = .left
        titleLabel.textColor = Color505050
        titleLabel.font = Font14
        titleLabel.text = "未来赛事"
        titleLabel.sizeToFit()
        
        teamName = getLabel()
        teamName.textColor = Color505050
        teamName.font = Font12
        teamName.textAlignment = .center
        
        teamLabel = getLabel()
        teamLabel.text = "赛事"
        
        dateLabel = getLabel()
        dateLabel.text = "日期"
        
        homeLabel = getLabel()
        homeLabel.text = "主队"
        
        visiLabel = getLabel()
        visiLabel.text = "客队"
        
        self.contentView.addSubview(hLine)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(teamName)
        self.contentView.addSubview(teamLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(homeLabel)
        self.contentView.addSubview(visiLabel)
        
        hLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.height.equalTo(1)
            make.left.right.equalTo(0)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(hLine.snp.top)
            make.left.equalTo(16 * defaultScale)
            make.width.equalTo(60)
        }
        teamName.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.bottom.equalTo(titleLabel)
        }
        teamLabel.snp.makeConstraints { (make) in
            make.top.equalTo(hLine.snp.bottom)
            make.bottom.equalTo(0)
            make.width.equalTo(70)
            make.left.equalTo(16 * defaultScale)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(teamLabel)
            make.left.equalTo(teamLabel.snp.right).offset(1)
            make.width.equalTo(visiLabel)
        }
        homeLabel.snp.makeConstraints { (make) in
            make.top.bottom.width.equalTo(dateLabel)
            make.left.equalTo(dateLabel.snp.right).offset(2)
        }
        visiLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(dateLabel)
            make.left.equalTo(homeLabel.snp.right).offset(2)
            make.right.equalTo(-6 * defaultScale)
        }
    }
    
    private func getLabel() -> UILabel{
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
