//
//  RouterMatcher.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON


enum PushControllerType {
    case 首页
    case 足球胜平负
    case 足球让球胜平负
    case none
}

struct URLModel : HandyJSON{
    var type: String!
    var id: String!
    var subid: String!
}

protocol RouterMatcher: URLParseProtocol {
    
}

extension RouterMatcher {
    
    
    func matcherHttp(urlStr: String) -> PushControllerType {
        let urlStr = "cxmxc=scm&type=0&id=http:baidu.com&subid=1"
        guard urlStr.contains("cxmxc=scm") else { return .none }
        
        let urlModel = parseUrl(urlStr: urlStr)
        
        switch urlModel?.type {
        case "0":
            return .首页
        default:
            return .none
        }
        
       
    }
}









