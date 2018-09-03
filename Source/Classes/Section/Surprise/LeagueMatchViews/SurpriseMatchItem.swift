//
//  SurpriseMatchItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class SurpriseMatchItem: UICollectionViewCell {
    
    static let width : CGFloat = 80
    static let height: CGFloat = 100
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
}

extension SurpriseMatchItem {
    public func configure(with data : LeagueInfoModel) {
        if let url = URL(string: data.leaguePic) {
            icon.kf.setImage(with: url)
        }
        title.text = data.leagueAddr
    }
    
    public func configure(with info : LeagueTeamInfo) {
        if let url = URL(string: info.teamPic) {
            icon.kf.setImage(with: url)
        }
        title.text = info.teamAddr
    }
}
