//
//  AppConfig.swift
//  彩小蜜
//
//  Created by D.Y on 2018/9/10.
//  Copyright © 2018年 CaiXiaoMi. All rights reserved.
//

import Foundation

let kBaseUrl = "baseurl"
let kBaseWebUrl = "baseweburl"

/// 是否已登录
public func hasLogin() -> Bool {
    //    方法一：
    //    let userinfo = UserDefaults.standard.object(forKey: "userInfo")
    //    if userinfo == nil {
    //        return false
    //    }else{
    //        return true
    //    }
    
    //    方法二：
    let token = UserInfoManager().getToken()
    if token.isEmpty {
        return false
    }else{
        return true
    }
    
    
}


/// 返回开发环境BaseUrl
///
/// - Returns: ApiUrl
public func platformBaseUrl() -> String! {
    let baseUrl = UserDefaults.standard.string(forKey: kBaseUrl) ?? "https://api.caixiaomi.net"
    var url = "https://api.caixiaomi.net"
    
    if baseUrl == "http://39.106.18.39:8765" {
        url = "http://39.106.18.39:8765"
    }else{
        url = "https://api.caixiaomi.net"
    }
    
    return url + "/api"
}

/// 获取当前开发环境类型
public func getCurrentPlatformType() -> String! {
    //测试环境：http://39.106.18.39:8765
    //        http://t1.caixiaomi.net:9805
    //生产环境：https://api.caixiaomi.net
    //        https://m.caixiaomi.net
    
    let url = UserDefaults.standard.string(forKey: kBaseUrl) ?? "https://api.caixiaomi.net"
    let baseUrl = NSURL(string: url)!
    if baseUrl.scheme == "https" {
        return "当前环境:生产环境"
    }else{
        return "当前环境:测试环境"
    }
}

/// 获取当前BaseWebUrl
public func getCurentBaseWebUrl() -> String! {
    let url = UserDefaults.standard.string(forKey: kBaseUrl) ?? "https://api.caixiaomi.net"
    let baseUrl = NSURL(string: url)!
    if baseUrl.scheme == "https" {
        return "https://m.caixiaomi.net"
    }else{
        return "http://192.168.31.205:3000"
        //return "http://t1.caixiaomi.net:9805"
    }
}

