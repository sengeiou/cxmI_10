//
//  UserInfoIconCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class UserInfoIconCell: UITableViewCell {

    public var model : SettingRowDataModel! {
        didSet{
            titleLabel.text = model.title
            icon.image = model.image
        }
    }
    
    private var titleLabel: UILabel!
    private var icon : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    private func initSubview() {
        titleLabel = UILabel()
        
        titleLabel.textColor = Color787878
        titleLabel.font = Font14
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        
        icon = UIImageView()
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(icon)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(16 * defaultScale)
        }
        
        icon.snp.makeConstraints { (make ) in
            make.right.equalTo(-10)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(icon.snp.height)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
