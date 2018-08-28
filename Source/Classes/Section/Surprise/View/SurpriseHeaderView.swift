//
//  SurpriseHeaderView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class SurpriseHeaderView: UITableViewHeaderFooterView {

    static let identifier = "SurpriseHeaderView"
    
    public var title : UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    private func initSubview() {
        title = UILabel()
        title.font = Font15
        title.textColor = ColorE85504
        title.textAlignment = .left
        title.text = "热门联赛"
        
        self.contentView.addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(0)
            make.left.equalTo(16 * defaultScale)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
