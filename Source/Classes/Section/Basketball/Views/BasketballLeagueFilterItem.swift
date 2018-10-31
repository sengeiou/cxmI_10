//
//  BasketballLeagueFilterItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/19.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class BasketballLeagueFilterItem: UICollectionViewCell {
    
    static let width : CGFloat = (screenWidth - 80) / 3 - 0.01
    static let height: CGFloat = 30
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSubview()
    }
    
    private func initSubview() {
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorF4F4F4.cgColor
    }
}

extension BasketballLeagueFilterItem {
    public func configure(with data : FilterModel) {
        title.text = data.leagueAddr
        
        switch data.isSelected {
        case true:
            title.textColor = ColorFFFFFF
            title.backgroundColor = ColorEA5504
        case false:
            title.textColor = Color505050
            title.backgroundColor = ColorFFFFFF
        }
    }
}
