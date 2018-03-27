//
//  AccountDetailSectionHeader.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class AccountDetailSectionHeader: UITableViewHeaderFooterView {

    public var accountDetail: AccountDetailModel! {
        didSet{
            title.text = accountDetail.addTime
        }
    }
    
    private var title : UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(1)
            make.bottom.equalTo(-1)
            make.left.equalTo(leftSpacing)
            make.right.equalTo(-rightSpacing)
        }
    }
    
    private func initSubview() {
        title = UILabel()
        title.font = Font15
        title.textColor = Color787878
        title.textAlignment = .left
        
        self.contentView.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
