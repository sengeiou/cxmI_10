//
//  RechargeTitleCell.swift
//  彩小蜜
//
//  Created by HX on 2018/3/20.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class RechargeTitleCell: UITableViewCell {

    public var userInfo  : UserInfoDataModel!{
        didSet{
            guard userInfo != nil else { return }
            account.text = "当前账号: \(userInfo.mobile!)"
            balance.text = "当前余额: \(userInfo.totalMoney!)"
        }
    }
    
    private var account : UILabel! // 账号
    private var balance : UILabel! // 余额
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        account.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.equalTo(self.contentView).offset(19)
            make.top.equalTo(self.contentView).offset(12)
        }
        balance.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.left.right.equalTo(account)
            make.bottom.equalTo(self.contentView).offset(-12)
        }
    }
    private func initSubview() {
        self.selectionStyle = .none
        
        account = UILabel()
        account.text = "当前账号: 114548655425365"
        account.font = Font15
        account.textColor = Color505050
        
        balance = UILabel()
        balance.text = "当前余额: 8888888元"
        balance.font = Font15
        balance.textColor = Color505050
        
        self.contentView.addSubview(account)
        self.contentView.addSubview(balance)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
