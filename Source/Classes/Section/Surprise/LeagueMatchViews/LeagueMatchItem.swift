//
//  LeagueMatchItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class LeagueMatchItem: UICollectionViewCell {
    
    static let width : CGFloat = (screenWidth - 20) / 3 - 0.01
    static let height: CGFloat = 40
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var leftLine: UIView!
    
    @IBOutlet weak var rightLine: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    
}

extension LeagueMatchItem {
    public func configure(with data : LeagueMatchModel) {
        if let url = URL(string: data.contryPic) {
            icon.kf.setImage(with: url)
        }
        title.text = data.contryName
    }
}
