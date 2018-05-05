//
//  Router.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

struct Router : RouterMatcher {
    func pushRouterVC(urlStr: String) {
        let type = matcherHttp(urlStr: urlStr)
        
        switch type {
        case .首页:
            break
        case .登录:
            break
        case .注册:
            break
        case .网页:
            break
        case .足球胜平负:
            break
        case .足球让球胜平负:
            break
        case .足球比分:
            break
        case .足球半全场:
            break
        case .足球总进球:
            break
        case .足球混合过关:
            break
        case .足球二选一:
            break
            
        default:
            break
        }
    }
}

