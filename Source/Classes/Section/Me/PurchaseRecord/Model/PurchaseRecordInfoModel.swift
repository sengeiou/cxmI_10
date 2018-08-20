//
//  PurchaseRecordInfoModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

struct PurchaseRecordInfoModel: HandyJSON {
    var lotteryName: String!
    var matchTime: String!
    var orderId : String!
    var orderSn : String!
    ///订单状态 0- 待付款 1- 待出票 2-出票失败 3-待开奖 4-未中奖 5-已中奖
    var orderStatus : String!
    var orderStatusDesc: String!
    var orderStatusInfo: String!
    var payTime: String!
    var ticketAmount: String!
    var winningMoner: String!
    var moneyPaid: String!
    /// 投注类型，0 - 竞彩 ， 1 - 世界杯
    var orderType : String!
    var lotteryClassifyId : String!
}
