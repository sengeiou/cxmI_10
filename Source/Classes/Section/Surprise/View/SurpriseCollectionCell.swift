//
//  SurpriseCollectionCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class SurpriseCollectionCell: UICollectionViewCell {
    
    static let width : CGFloat = 80
    static let height : CGFloat = 100
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var suTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.image = UIImage(named: "SuperLtto")
    }
    
    
}

extension SurpriseCollectionCell {
    public func configure(with info : SurpriseItemInfo) {
        if let url = URL(string: info.classImg) {
            icon.kf.setImage(with: url)
        }
        title.text = info.className
        suTitle.text = info.subTitle
    }
    public func configure(with info : SurpriseLeagueInfo) {
        if let url = URL(string: info.actUrl) {
            icon.kf.setImage(with: url)
        }
        title.text = info.title
        suTitle.text = info.detail
    }
    
}
