//
//  ShopBannerItem.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/27.
//  Copyright © 2018 韩笑. All rights reserved.
//

import UIKit

class ShopBannerItem: UICollectionViewCell {
    
    static let identifier : String = "ShopBannerItem"
    
    var bannerView : BannerView!
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShopBannerItem {
    public func configure(with data : [BannerModel]) {
        bannerView.bannerList = data
    }
}

// MARK: 初始化
extension ShopBannerItem {
    private func initSubview() {
        bannerView = BannerView()
        
        self.contentView.addSubview(bannerView)
        
        bannerView.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(0)
        }
    }
}
