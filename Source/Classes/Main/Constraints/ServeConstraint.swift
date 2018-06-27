//
//  ServeConstraint.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//



#if DEBUG
let baseURLStr = "http://39.106.18.39:8765/api"
let baseWeb = "http://39.106.18.39:9805"
//
//let baseWeb = "http://192.168.31.205:8080"


//let baseURLStr = "http://api.caixiaomi.net/api"
//let baseWeb = "http://m.caixiaomi.net"
#else
let baseURLStr = "https://api.caixiaomi.net/api"
let baseWeb = "https://m.caixiaomi.net"
#endif


/// 安全保障
let webInsurance = "\(baseWeb)/user/insurance?showtitle=1"
/// 帮助中心
let webHelp = "\(baseWeb)/user/help?showtitle=1"
/// 玩法帮助
let webPlayHelp = "\(baseWeb)/freebuy/inToplay?showtitle=1"
/// 购彩协议
let webBuyAgreement = "\(baseWeb)/freebuy/protocol?showtitle=1"
/// 注册协议
let webRegisterAgreement = "\(baseWeb)/user/service?showtitle=1"
/// 发现
let SurpriseUrl = "\(baseWeb)/find?showBar=1&showtitle=1&from=app_find"
/// 胆说明
let danExplainUrl = "\(baseWeb)/freebuy/explain?showBar=1&showtitle=1"
