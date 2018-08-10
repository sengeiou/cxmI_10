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

struct DLTLottoNumInfo: HandyJSON {
    var numList : [String]!
    /// 期号
    var termNum: String!
}

struct DLTHotOrCold : HandyJSON {
    var countA: String!
    var countB: String!
    var countC: String!
    var drop: String!
    var num: String!
}
struct DLTTrendInfo : HandyJSON {
    var averageData : [String]!
    var countNum: [String]!
    var drop : [DLTLottoNumInfo]!
    var maxContinue : [String]!
    var maxData : [String]!
}
