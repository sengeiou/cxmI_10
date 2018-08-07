//
//  DaletouOmissionModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/8/1.
//  Copyright © 2018年 韩笑. All rights reserved.
//  大乐透 遗漏数据

import Foundation
import HandyJSON
struct DaletouOmissionModel : HandyJSON {
    
    var endDate : String!
    /// 后去遗漏
    var postList : [String]!
    /// 前区遗漏
    var preList : [String]!
    /// 历史中奖纪录
    var prizeList : [DLTHistoricalData]!
    var prizes : String!
    var term_num : String!
    
}

struct DLTHistoricalData : HandyJSON {
    var numList : [String]!
    var termNum : String!
}
