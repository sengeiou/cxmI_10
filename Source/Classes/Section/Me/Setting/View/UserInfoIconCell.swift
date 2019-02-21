//
//  UserInfoIconCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/6/25.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

fileprivate let iconTopSpacing : CGFloat = 5

class UserInfoIconCell: UITableViewCell {

    static let cellHeight : CGFloat = 60
    
    public var model : SettingRowDataModel! {
        didSet{
            titleLabel.text = model.title
            icon.image = model.image
        }
    }
    
    private var titleLabel: UILabel!
    private var icon : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubview()
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        titleLabel = UILabel()
        
        titleLabel.textColor = Color787878
        titleLabel.font = Font14
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        
        icon = UIImageView()
        icon.layer.cornerRadius = (UserInfoIconCell.cellHeight - iconTopSpacing * 2) / 2
        icon.layer.masksToBounds = true
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(icon)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(16 * defaultScale)
        }
        
        icon.snp.makeConstraints { (make ) in
            make.right.equalTo(-10)
            make.top.equalTo(iconTopSpacing)
            make.bottom.equalTo(-iconTopSpacing)
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
