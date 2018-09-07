//
//  TeamDetailMemberItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/7.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class TeamDetailMemberItem: UICollectionViewCell {
    
    static let width : CGFloat = (screenWidth - 34) / 2 - 0.01
    static let height: CGFloat = 30
    
    @IBOutlet weak var topLine : UIView!
    @IBOutlet weak var bottomLine : UIView!
    @IBOutlet weak var leftLine : UIView!
    @IBOutlet weak var rightLine : UIView!
    
    @IBOutlet weak var title : UILabel!
    
}

extension TeamDetailMemberItem {
    public func configure(with data : TeamMemberInfo) {
        title.text = data.playerName
    }
}
