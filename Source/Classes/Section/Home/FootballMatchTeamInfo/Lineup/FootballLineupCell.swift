//
//  FootballLineupCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/6.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class FootballLineupCell: UITableViewCell {

    static let identifier: String = "FootballLineupCell"
    
    private var backImageView : UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initBackView()
        initSubview()
    }
    
    private func initSubview() {
        
        
    }

    private func initBackView() {
        backImageView = UIImageView()
        backImageView.image = UIImage(named: "球场底图")
        
        self.contentView.addSubview(backImageView)
        
        backImageView.snp.makeConstraints { (make) in
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
