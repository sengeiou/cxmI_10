//
//  AppKeyConstraint.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

/// 微信分享
let WeixinAppID = "wx1767896f012e05a2"

/// 百度统计
let BaiduAppKey = "8b4996b71f"

/// 智齿客服
let ZhiChiAppKey = "193e17343a3b430a9d21af67c92f5491"
/// 渠道
let Channel = "c36010"

let phoneNum = "400-012-6600"

let website = "http://www.renrentiyua.com"

/// 主程序版本号
let majorVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String


/// 个推
#if DEBUG
    let GetuiAppID  = "SQ3WV0duEo5YipEvzlaXS2"
    let GetuiAppKey = "Y1seeH4pyr7TCBEZDNwaF"
    let GetuiSecrct = "svMsjRq4LR6gT6RZk8rfO9"

#else
    let GetuiAppID  = "NRtMIfLwdc7LTbK7sf0Kn"
    let GetuiAppKey = "EQ3i8BjTze9buaOPD9gHn1"
    let GetuiSecrct = "lERUWPih8JAgrXaoO62u88"
#endif

// test

