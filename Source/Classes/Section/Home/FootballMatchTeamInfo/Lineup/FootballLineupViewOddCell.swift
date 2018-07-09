//
//  FootballLineupViewOddCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//  奇数

import UIKit

class FootballLineupViewOddCell: UITableViewCell {

    static let identifier = "FootballLineupViewOddCell"
    
    public var lineupList : [FootballLineupMemberInfo]! {
        didSet{
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        initSubview()
    }
    
    private func initSubview() {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
