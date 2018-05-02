//
//  RouterMatcher.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

enum PushController {
    case fd
}

protocol RouterMatcher {
    
}

extension RouterMatcher {
    func matcherHttp() -> PushController {
        return .fd
    }
}
