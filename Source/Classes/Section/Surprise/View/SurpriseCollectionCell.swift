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
    public func configure(with info : LeagueInfoModel) {
        if let url = URL(string: info.leaguePic) {
            icon.kf.setImage(with: url)
            
            icon.kf.setImage(with: url, placeholder: nil , options: nil , progressBlock: nil) { (image, error , type, url) in
                if let ima = image {
                    let size = ima.scaleImage(image: ima, imageLength: SurpriseCollectionCell.width - 20)
                    self.icon.snp.remakeConstraints { (make) in
                        make.top.equalTo(0)
                        make.left.equalTo(10)
                        make.right.equalTo(-10)
                        make.size.equalTo(size)
                    }
                }
            }
            
        }
        title.text = info.leagueAddr
        suTitle.text = ""
        
    }
    
}
