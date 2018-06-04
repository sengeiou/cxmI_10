//
//  RouterMatcher.swift
//  彩小蜜
//
//  Created by 笑 on 2018/5/2.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON


enum PushControllerType : String{
    case 首页
    case 网页
    case 浏览器
    case 足球胜平负 = "2"
    case 足球让球胜平负 = "1"
    case 足球总进球 = "4"
    case 足球半全场 = "5"
    case 足球比分 = "3"
    case 足球混合过关 = "6"
    case 足球二选一 = "7"
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
    var cmshare: String!
    /// 是否需要传token
    var usInfo: String!
    /// 获取函数名
    var extparam: String!
}

protocol RouterMatcher: URLParseProtocol {
    
}

extension RouterMatcher {
    
    
    func matcherHttp(urlStr: String) -> (PushControllerType, URLModel? ){
        
        guard let urlStr = urlStr.removingPercentEncoding else { return (.none, nil) }
        guard urlStr.contains("cxmxc=scm") else { return (.浏览器, nil) }
        
        guard let urlModel = parseUrl(urlStr: urlStr) else { return (.none, nil ) }
        
        switch urlModel.type {
        case "0":
            return (.首页, urlModel)
        case "1":
            return (.网页, urlModel)
        case "3":
            if urlModel.id == "1", urlModel.subid != nil {
                return matcherFootballPlay(subid: (urlModel.subid)!)
            }else {
                return (.none, urlModel)
            }
            
        case "4":
            return (.球队详情, urlModel)
        case "5":
            return (.登录, urlModel)
        case "6":
            return (.注册, urlModel)
        case "8":
            return (.咨询详情, urlModel)
        default:
            return (.none, urlModel)
        }
    }
    
    private func matcherFootballPlay(subid: String) -> (PushControllerType, URLModel? ) {
        switch subid {
        case "1":
            return (.足球让球胜平负, nil )
        case "2":
            return (.足球胜平负, nil )
        case "3":
            return (.足球比分, nil )
        case "4":
            return (.足球总进球, nil )
        case "5":
            return (.足球半全场, nil )
        case "6":
            return (.足球混合过关, nil )
        case "7":
            return (.足球二选一, nil )
        default:
            return (.none, nil )
        }
    }
}









