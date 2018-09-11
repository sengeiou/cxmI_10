//
//  LeagueDetailCourseHeader.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/10.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class LeagueDetailScoreHeader: UITableViewHeaderFooterView {

    static let identifier : String = "LeagueDetailScoreHeader"
    
    private var title : UILabel!
    
    private var topLine : UIView!
    private var leftLine : UIView!
    private var rightLine : UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    private func initSubview() {
        topLine = UIView()
        leftLine = UIView()
        rightLine = UIView()
        
        topLine.backgroundColor = ColorF4F4F4
        leftLine.backgroundColor = ColorF4F4F4
        rightLine.backgroundColor = ColorF4F4F4
        
        title = UILabel()
        title.font = Font14
        title.textAlignment = .left
        title.textColor = Color505050
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(topLine)
        self.contentView.addSubview(leftLine)
        self.contentView.addSubview(rightLine)
        
        topLine.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(1)
        }
        leftLine.snp.makeConstraints { (make) in
            make.top.equalTo(topLine)
            make.bottom.equalTo(0)
            make.width.equalTo(1)
            make.left.equalTo(16)
        }
        rightLine.snp.makeConstraints { (make) in
            make.top.equalTo(topLine)
            make.bottom.equalTo(0)
            make.width.equalTo(1)
            make.right.equalTo(-16)
        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(topLine.snp.bottom)
            make.right.equalTo(rightLine.snp.left)
            make.bottom.equalTo(-1)
            make.left.equalTo(leftLine.snp.right).offset(5)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LeagueDetailScoreHeader {
    public func configure(with data : String) {
        self.title.text = data
    }
}
