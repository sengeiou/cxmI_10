//
//  CouponInfoModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct CouponInfoModel: HandyJSON {
    var bonusId: String!
    var bonusName : String!
    var bonusPrice : String!
    var bonusStatus: String!
    var bonusType : String!
    var isCanReceive : String!
    var limitTime : String!
    var minGoodsAmount : String!
    var useRange : String!
    var userBonusId : String!
    ///快过期标志：1-显示 0-隐藏
    var soonExprireBz: String!
}
