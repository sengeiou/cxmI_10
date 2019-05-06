//
//  AppKeyConstraint.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

/// 微信分享
let WeixinAppID = "wx87a74970342bfefd"

/// 百度统计 BAIDU_APP_KEY: "44482325ea"
let BaiduAppKey = "44482325ea"


/// 智齿客服
let ZhiChiAppKey = "193e17343a3b430a9d21af67c92f5491"
/// 渠道
let Channel = "c46016"

let phoneNum = "400-012-6600"

let website = "http://www.renrentiyua.com"

/// 主程序版本号
let majorVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String

/// 个人资料闪屏
var turnOn = false

/*	
 应用名称： 圣河彩店
 appId： AJ2aStM5OS63nUuQD7TVu3
 appSecret： fguquBeDT39WFcqjjixAo8
 appKey： 81rV5jRDQx8HyL5hVJbR
 应用包名： com.shenghecp.selltool
 应用签名： 0D:6A:3F:FB:F9:99:FB:6C:9B:57:61:9E:A9:17:84:5E:C8:BF:8B:14:7D:30:A7:D7:C0:13:A1:64:08:32:9E:E2
 iOS bundleID： com.shenghecaidian.itools
 masterSecret：
 【个推】 3XlcmmSaF46jL96roGqhU4
 */

/// 个推
#if DEBUG
let GetuiAppID  = "AJ2aStM5OS63nUuQD7TVu3"
let GetuiAppKey = "81rV5jRDQx8HyL5hVJbR"
let GetuiSecrct = "fguquBeDT39WFcqjjixAo8"

#else
let GetuiAppID  = "AJ2aStM5OS63nUuQD7TVu3"
let GetuiAppKey = "81rV5jRDQx8HyL5hVJbR"
let GetuiSecrct = "fguquBeDT39WFcqjjixAo8"

#endif

// test


