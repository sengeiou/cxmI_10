//
//  UserInfoSettingHeaderView.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class UserInfoSettingHeaderView: UITableViewHeaderFooterView {

    public var title : UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubview()
        
        
    }
    
    private func initSubview() {
        
        
        title = UILabel()
        title.font = Font14
        title.textColor = Color787878
        title.textAlignment = .left
        
        self.contentView.addSubview(title)
        
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(16 * defaultScale)
            make.right.equalTo(-16 * defaultScale)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
