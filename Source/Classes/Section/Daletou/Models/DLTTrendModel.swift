//
//  DLTTrendModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/9.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct DLTTrendModel: HandyJSON {
    var lottoNums : [DLTLottoNumInfo]!
    /// 蓝球冷热
    var postHeatColds : [DLTHotOrCold]!
    /// 红球冷热
    var preHeatColds : [DLTHotOrCold]!
    /// 蓝球走势
    var postLottoDrop : DLTTrendInfo!
    /// 红球走势
    var preLottoDrop: DLTTrendInfo!
    /// 截止时间
    var stopTime: String!
    
}
enum TermStyle {
    case 出现次数
    case 平均遗漏
    case 最大遗漏
    case 最大连出
    case 默认
}
struct DLTLottoNumInfo: HandyJSON {
    var numList : [String]!
    /// 期号
    var termNum: String!
    var termStyle : TermStyle = .默认
}

struct DLTHotOrCold : HandyJSON {
    var countA: String!
    var countB: String!
    var countC: String!
    var drop: String!
    var num: String!
}
struct DLTTrendInfo : HandyJSON {
    /// 平均遗漏
    var averageData : [String]!
    /// 出现次数
    var countNum: [String]!
    var drop : [DLTLottoNumInfo]!
    /// 最大连出
    var maxContinue : [String]!
    /// 最大遗漏
    var maxData : [String]!
}
