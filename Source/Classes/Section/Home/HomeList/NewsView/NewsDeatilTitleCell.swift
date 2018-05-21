//
//  NewsDeatilTitleCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class NewsDeatilTitleCell: UITableViewCell {

    private var title : UILabel!
    private var bottomLine: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initSubview()
    }

    private func initSubview() {
        bottomLine = UIView()
        bottomLine.backgroundColor = ColorC8C8C8
        
        title = UILabel()
        title.text = "相关文章"
        title.font = Font18
        title.textColor = Color505050
        title.textAlignment = .center
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(bottomLine)
        title.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(0)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(-0)
            make.height.equalTo(0.5)
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
