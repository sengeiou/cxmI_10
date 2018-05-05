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
    case 网页
    case 足球胜平负
    case 足球让球胜平负
    case 足球总进球
    case 足球半全场
    case 足球比分
    case 足球混合过关
    case 足球二选一
    case 球队详情
    case 咨询详情
    case 登录
    case 注册
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
        case "1":
            return .网页
        case "3":
            if urlModel?.id == "1", urlModel?.subid != nil {
                return matcherFootballPlay(subid: (urlModel?.subid)!)
            }else {
                return .none
            }
        case "4":
            return .球队详情
        case "5":
            return .登录
        case "6":
            return .注册
        case "8":
            return .咨询详情
        default:
            return .none
        }
    }
    
    private func matcherFootballPlay(subid: String) -> PushControllerType {
        switch subid {
        case "1":
            return .足球让球胜平负
        case "2":
            return .足球胜平负
        case "3":
            return .足球比分
        case "4":
            return .足球总进球
        case "5":
            return .足球半全场
        case "6":
            return .足球混合过关
        case "7":
            return .足球二选一
       
        default:
            return .none
        }
    }
}









