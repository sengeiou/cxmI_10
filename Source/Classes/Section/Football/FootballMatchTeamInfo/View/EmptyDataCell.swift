//
//  EmptyDataCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/24.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class EmptyDataCell: UITableViewCell {

    static let identifier = "EmptyDataCellId"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubView()
    }
    
    private func initSubView() {
        self.selectionStyle = .none
        
        let title = UILabel()
        title.font = Font14
        title.textColor = Color787878
        title.textAlignment = .center
        title.text = "暂无数据"
        
        let line = UIImageView(image: UIImage(named: "line"))
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        title.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
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
