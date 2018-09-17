//
//  LeagueMatchItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/30.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import UIKit

class LeagueMatchItem: UICollectionViewCell {
    
    static let width : CGFloat = (screenWidth - 32) / 3 - 0.01
    static let height: CGFloat = 40
    
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var leftLine: UIView!
    
    @IBOutlet weak var rightLine: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //title.font = Font12
    }
}

extension LeagueMatchItem {
    public func configure(with data : LeagueMatchModel) {
//        if let url = URL(string: data.contryPic) {
//            icon.kf.setImage(with: url, placeholder: nil , options: nil , progressBlock: nil) { (image, error, type , url) in
//                if let ima = image {
//                    let size = ima.scaleImage(image: ima, imageLength: 12)
//                    
//                    self.icon.snp.remakeConstraints { (make) in
//                        make.centerY.equalTo(self.contentView.snp.centerY)
//                        make.left.equalTo(self.leftLine.snp.right).offset(10)
//                        make.size.equalTo(size)
//                    }
//                }
//            }
//        }
        title.text = data.contryName
    }
    
    public func configure(with data : LeagueInfoModel) {
//        if let url = URL(string: data.leaguePic) {
//            icon.kf.setImage(with: url)
//        }
        title.text = data.leagueAddr
    }
    
}
