//
//  FootballOddsTitleCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/17.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballOddsTitleCell: UITableViewCell {

    public var pagerView: FootballOddsPagerView!
    public var titleView: FootballOddsTitleView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        pagerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(36 * defaultScale)
        }
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(pagerView.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
    }
    private func initSubview() {
        pagerView = FootballOddsPagerView()
        titleView = FootballOddsTitleView()
        
        self.contentView.addSubview(pagerView)
        self.contentView.addSubview(titleView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
