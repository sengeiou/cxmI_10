//
//  AccountStatisticsModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/27.
//  Copyright © 2018年 韩笑. All rights reserved.
//  统计数据

import Foundation
import HandyJSON

struct AccountStatisticsModel: HandyJSON {
    var buyMoney: String!
    var rechargeMoney: String!
    var rewardMoney: String!
    var withDrawMoney: String!
}
