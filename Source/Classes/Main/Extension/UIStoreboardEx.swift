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
        case Basketball
        case Storyboard
        case Shop
        case Seller
    }
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
}
