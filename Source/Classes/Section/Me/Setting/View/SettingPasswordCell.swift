//
//  SettingPasswordCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/31.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class SettingPasswordCell: UITableViewCell {

    public var title : UILabel!
    public var textField : UITextField!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
        
    }
    
    private func initSubview() {
        title = UILabel()
        title.font = Font14
        title.textColor = Color787878
        title.textAlignment = .left
        
        textField = UITextField()
        
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(textField)
        
        title.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(16 * defaultScale)
            make.width.equalTo(80)
        }
        textField.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(title)
            make.right.equalTo(-16 * defaultScale)
            make.left.equalTo(title.snp.right).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
