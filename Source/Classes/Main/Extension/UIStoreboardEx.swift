//
//  UIStoreboardEx.swift
//  彩小蜜
//
//  Created by 笑 on 2018/9/18.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

extension UIStoryboard {
    enum Storyboard: String {
        /// 篮球
        case Basketball
        
        case Storyboard
        /// 商城
        case Shop
        /// 店铺
        case Seller
        /// 发现
        case Surprise
        /// 足球
        case Football
        /// 电竞
        case ESports
    }
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
}
