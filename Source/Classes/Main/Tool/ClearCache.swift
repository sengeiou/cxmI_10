//
//  ClearCache.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import Kingfisher

protocol ClearCache {
    
}

extension ClearCache {
    func clearImageCache() {
        let cache = ImageCache.default
        cache.clearDiskCache()
        //cache.clearMemoryCache()
        cache.cleanExpiredDiskCache()
    }
}
