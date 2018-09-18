//
//  SurpriseMatchItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/28.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class SurpriseMatchItem: UICollectionViewCell {
    
    static let width : CGFloat = (screenWidth - 32) / 3 - 0.01
    static let height: CGFloat = 40
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var leftLine: UIView!
    
    @IBOutlet weak var rightLine: UIView!
    
    //@IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.textColor = Color505050
    }
    
}

extension SurpriseMatchItem {
    public func configure(with data : LeagueInfoModel) {
//        if let url = URL(string: data.leaguePic) {
//            icon.kf.setImage(with: url, placeholder: nil , options: nil , progressBlock: nil) { (image, error, type , url) in
//                if let ima = image {
//                    let size = ima.scaleImage(image: ima, imageLength: SurpriseMatchItem.height - 40)
//                    self.icon.snp.remakeConstraints { (make) in
//                        make.top.equalTo(0)
//                        make.centerX.equalTo(self.contentView.snp.centerX)
//                        make.size.equalTo(size)
//                    }
//                }
//            }
//        }
        title.text = data.leagueAddr
    }
    
    public func configure(with info : LeagueTeamInfo) {
//        if let url = URL(string: info.teamPic) {
//            icon.kf.setImage(with: url)
//        }
        title.text = info.teamAddr
    }
}
