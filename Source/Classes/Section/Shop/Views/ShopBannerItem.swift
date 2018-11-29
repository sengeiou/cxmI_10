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
        
        var model = BannerModel()
        model.bannerImage = "https://static.caixiaomi.net/uploadImgs/20181127/098ceeeef00a4232938979fa2c1bcb59.png"
        model.bannerLink = "http://caixiaomi.net?cxmxc=scm&type=8&showBar=1&from=app&showtitle=1&id=1518"
        model.bannerName = "欧战明天凌晨即将上演"
        bannerView.bannerList = [model,model,model]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
